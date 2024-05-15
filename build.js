
/**
 * Dependencies: Git, Maven, Docker
 * 
 * Start by running `node build.js reset`
 */

const util = require("util");
const child_process = require("child_process");
const fs = require("fs");
const { chdir, argv } = require("process");

const exec = util.promisify(child_process.exec);
const rm = util.promisify(fs.rm);
const readdir = util.promisify(fs.readdir);
const writeFile = util.promisify(fs.writeFile);


/* Gets repository name from URL or command
 */
const getRepositoryName = repository => {
    const tokens = repository.split("/");
    return tokens[tokens.length - 1];
}

/* Function for cloning all repositories in repositories array
 */
const cloneRepositories = async repositories => {
    const gitCommands = repositories.map(repo => "git clone " + repo);

    for (const command of gitCommands) {
        console.log(`Cloning ${getRepositoryName(command)}...`);
        await exec(command);
    }
};

/* Function for removing repository directories
 */
const removeRepositories = async repositories => {
    const directories = repositories.map(getRepositoryName);

    for (const directory of directories) {
        try {
            console.log(`Removing ${directory}...`);
            await rm(directory, { recursive: true });
        } catch (err) {
            console.log(`${directory} does not exist...`);
        }
    }
};

/* Builds all backend projects
 */
const buildBackendRepositories = async backendRepositories => {
    const directories = backendRepositories.map(getRepositoryName);

    for (const directory of directories) {
        console.log(`Packaging ${directory}...`);
        chdir(directory);
        await exec("mvn package -DskipTests");
        chdir("..");
    }
};

/* Containerizes all backend projects
 */
const containerizeBackendRepositories = async backendRepositories => {
    const portsTable = {
        "budget-buddy-accountservice": 8080,
        "budget-buddy-budgetservice": 8080,
        "budget-buddy-taxservice": 8084,
        "budget-buddy-userservice": 8081,
        "budget-buddy-transactionservice": 8083,
        "budget-buddy-gatewayservice": 8125,
        "budget-buddy-discoveryservice": 8761,
    };

    const directories = backendRepositories.map(getRepositoryName);

    for (const directory of directories) {
        console.log(`Containerizing ${directory}...`);
        chdir(directory);
        const files = await readdir(".");
        if (!files.includes("Dockerfile")) {
            const targetFiles = await readdir("target");
            const jarFile = targetFiles.filter(file => file.substring(file.length - 4, file.length) === ".jar");
            await writeFile("Dockerfile", `FROM eclipse-temurin:17-jre-alpine
RUN apk update
RUN apk upgrade
WORKDIR /app
COPY target/${jarFile[0]} /app/app.jar
EXPOSE ${portsTable[directory.toLowerCase()]}
CMD ["java", "-jar", "app.jar"]
`);
        }
        await exec(`docker build -t ${directory.toLowerCase()} .`);
        chdir("..");
    }
};


const frontendRepository = "https://github.com/My-Budget-Buddy/Budget-Buddy-Frontend";

const backendRepositories = [
    "https://github.com/My-Budget-Buddy/Budget-Buddy-AccountService",
    //"https://github.com/My-Budget-Buddy/Budget-Buddy-BudgetService",
    "https://github.com/My-Budget-Buddy/Budget-Buddy-TaxService",
    "https://github.com/My-Budget-Buddy/Budget-Buddy-UserService",
    "https://github.com/My-Budget-Buddy/Budget-Buddy-TransactionService",
    "https://github.com/My-Budget-Buddy/Budget-Buddy-GatewayService",
    "https://github.com/My-Budget-Buddy/Budget-Buddy-DiscoveryService",
];

const repositories = backendRepositories.concat([frontendRepository]);

const main = async () => {
    if (argv.length > 2 && argv[2] === "clean") {
        await removeRepositories(repositories);
        return;
    }

    if (argv.length > 2 && argv[2] === "reset") {
        await removeRepositories(repositories);
        console.log();
        await cloneRepositories(repositories);
        console.log();
    }
    await buildBackendRepositories(backendRepositories);
    console.log();
    await containerizeBackendRepositories(backendRepositories);
};

main();
