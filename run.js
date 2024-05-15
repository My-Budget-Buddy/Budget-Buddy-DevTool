
/**
 * Dependencies: Git, Maven, Docker
 * 
 * Start by running `node build.js reset`
 */

const util = require("util");
const child_process = require("child_process");

const exec = util.promisify(child_process.exec);


const images = [
    {name: "budget-buddy-accountservice", innerPort: 8080, outerPort: 8080},
    //{name: "budget-buddy-budgetservice", innerPort: 8080, outerPort: 8082},
    {name: "budget-buddy-taxservice", innerPort: 8084, outerPort: 8084},
    {name: "budget-buddy-userservice", innerPort: 8081, outerPort: 8081},
    {name: "budget-buddy-transactionservice", innerPort: 8083, outerPort: 8083},
    {name: "budget-buddy-gatewayservice", innerPort: 8125, outerPort: 8125},
    {name: "budget-buddy-discoveryservice", innerPort: 8761, outerPort: 8761},
];

const main = async () => {
    for (const image of images) {
        console.log(`Starting container ${image.name}...`);
        await exec(`docker run -dp ${image.outerPort}:${image.innerPort} ${image.name}`);
    }
};

main();
