
/**
 * Dependencies: Git, Maven, Docker
 * 
 * Start by running `node build.js reset`
 */

const util = require("util");
const child_process = require("child_process");

const exec = util.promisify(child_process.exec);


const databaseRootUrl = "jdbc:postgresql://host.docker.internal:5432";
const databaseUsername = "postgres";
const databasePassword = "password";
const eurekaUrl = "http://host.docker.internal:8761/eureka";
const frontendUrl = "http://host.docker.internal:5176";


const images = [
    {
        name: "budget-buddy-accountservice",
        innerPort: 8080,
        outerPort: 8080,
        environmentVariables: {
            "DATABASE_URL": databaseRootUrl + "/accounts",
            "DATABASE_USERNAME": databaseUsername,
            "DATABASE_PASSWORD": databasePassword,
            "EUREKA_URL": eurekaUrl,
        },
    },
    // {
    //     name: "budget-buddy-budgetservice",
    //     innerPort: 8080,
    //     outerPort: 8082,
    //     environmentVariables: {
    //         "DATABASE_URL": databaseRootUrl + "/budgets",
    //         "DATABASE_USERNAME": databaseUsername,
    //         "DATABASE_PASSWORD": databasePassword,
    //         "EUREKA_URL": eurekaUrl,
    //     },
    // },
    {
        name: "budget-buddy-taxservice",
        innerPort: 8084,
        outerPort: 8084,
        environmentVariables: {
            "DATABASE_URL": databaseRootUrl + "/tax-service",
            "DATABASE_USER": databaseUsername,
            "DATABASE_PASS": databasePassword,
            "EUREKA_URL": eurekaUrl,
        },
    },
    {
        name: "budget-buddy-userservice",
        innerPort: 8081,
        outerPort: 8081,
        environmentVariables: {
            "DATABASE_URL": databaseRootUrl + "/budget-buddy-users",
            "DATABASE_USERNAME": databaseUsername,
            "DATABASE_PASSWORD": databasePassword,
            "EUREKA_URL": eurekaUrl,
        },
    },
    {
        name: "budget-buddy-transactionservice",
        innerPort: 8083,
        outerPort: 8083,
        environmentVariables: {
            "DATABASE_URL": databaseRootUrl + "/test_transaction",
            "DATABASE_USER": databaseUsername,
            "DATABASE_PASS": databasePassword,
            "EUREKA_URL": eurekaUrl,
        },
    },
    {
        name: "budget-buddy-gatewayservice",
        innerPort: 8125,
        outerPort: 8125,
        environmentVariables: {
            "FRONTEND_URL": frontendUrl,
            "EUREKA_URL": eurekaUrl,
        },
    },
    {
        name: "budget-buddy-discoveryservice",
        innerPort: 8761,
        outerPort: 8761,
        environmentVariables: {
        },
    },
];


const main = async () => {
    for (const image of images) {
        console.log(`Starting container ${image.name}...`);
        const environmentArguments = [];
        for (const environmentVariable in image.environmentVariables) {
            environmentArguments.push(`-e ${environmentVariable}=${image.environmentVariables[environmentVariable]}`);
        }
        await exec(`docker run -d ${environmentArguments.join(" ")} -p ${image.outerPort}:${image.innerPort} ${image.name}`);
    }
};

main();
