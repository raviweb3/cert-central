// What I don't like about the inbuilt deploy script is the inability
// to pass args/params into the function from the terminal.
// This is why I default to a task for deployment
// could MAYBE something like npx hardhat run scripts/deploy.js --network rinkeby --constructor-args arguments/greeter.arguments.js
// but too much hassle for me

import hre from 'hardhat';
import path from 'path';

import type { Greeter } from '../typechain-types/Greeter';
import type { Greeter__factory } from '../typechain-types/factories/Greeter__factory';

async function main() {
  console.log('Greetings fil-der! Im deploying Greeter');
  const greeterFactory: Greeter__factory = <Greeter__factory>(
    await hre.ethers.getContractFactory('Greeter')
  );

  const priorityFee = await hre.run('callRPC', {
    method: 'eth_maxPriorityFeePerGas',
    params: [],
  });

  const greeter: Greeter = <Greeter>await greeterFactory.deploy(
    'Hello, World!',
    {
      maxPriorityFeePerGas: priorityFee,
    }
  );
  await greeter.deployed();
  console.log('Success! Greeter deployed to address:', greeter.address);

  //Optional: Log to a file for reference
  await hre.run('logToFile', {
    filePath: path.resolve(__dirname, 'log.txt'),
    data: greeter,
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
