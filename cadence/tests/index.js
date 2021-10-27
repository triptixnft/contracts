import {  init,
    emulator,
    executeScript,
    getAccountAddress,
    deployContractByName,
    getTransactionCode,
    mintFlow,
    sendTransaction } from "flow-js-testing";

import path from "path";

import { fileURLToPath } from 'url';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const main = async () => {
  const basePath = path.resolve(__dirname, "../");
  const port = 8080;

  // Init framework
  await init(basePath, { port });

  // Start emulator
  await emulator.start(port);

  let step = 0;

  // Creating two accounts to represent TheMasterPiece Owner and Users
  console.log(`\nStep ${step++}`, "Accounts created");
  const TMPOwner = await getAccountAddress("TMPOwner");
  const TMPUser1 = await getAccountAddress("TMPUser1");
  const TMPUser2 = await getAccountAddress("TMPUser2");

  console.log(`\nStep ${step++}`, "Flow minted and provided to the accounts");
  try {
    const amount = "1000.0";
    const mintResult0 = await mintFlow(TMPOwner, amount);
    const mintResult1 = await mintFlow(TMPUser1, amount);
    const mintResult2 = await mintFlow(TMPUser2, amount);
    console.log({ mintResult0, mintResult1, mintResult2 });
  } catch (e) {
    console.error(e);
  }


  const addressMap = { TheMasterPieceContract: TMPOwner, TheMasterPixelContract: TMPOwner, FungibleToken: "0xee82856bf20e2aa6", FlowToken: "0x0ae53cb6e3f42a79"}


  // Querying balances
  console.log(`\nStep ${step++}`, "Get Balances");
  try {
    const tx = await executeScript({name: "GetBalance", args: [TMPOwner], addressMap: addressMap});
    const tx1 = await executeScript({name: "GetBalance", args: [TMPUser1], addressMap: addressMap});
    const tx2 = await executeScript({name: "GetBalance", args: [TMPUser2], addressMap: addressMap});
    console.log("Balance ", { tx, tx1, tx2 });
  } catch (e) {
    console.error(e);
  }

  // All contracts are on "../cadence/contracts/*.cdc" path
  // Deploying Contracts
  console.log(`\nStep ${step++}`, "All contracts deployed");
  try {
    const deploymentResult0 = await deployContractByName({ to: TMPOwner, name:  "TheMasterPieceContract", addressMap: addressMap});
    console.log("TheMasterPieceContract deployed", { deploymentResult0 });

    const deploymentResult1 = await deployContractByName({ to: TMPOwner, name:  "TheMasterPixelContract", addressMap: addressMap});
    console.log("TheMasterPixelContract deployed", { deploymentResult1 });

    const deploymentResult2 = await deployContractByName({ to: TMPOwner, name:  "TheMasterMarketContract", addressMap: addressMap});
    console.log("TheMasterMarketContract deployed", { deploymentResult2 });
  } catch (e) {
    // If we encounter any errors during teployment, we can catch and process them here
    console.error(e);
  }

  // We have made the choice to provide tests following a simple user story
  // Project codes are so simple that splitting unitary and intergration tests will not provide additional useful coverage and test cases
  // The first tests will follow the user story as expected, they are covering all public functions provided in the smartcontracts
  // The last tests will target expected issues on specific functions

  // User Story:
  // TheMasterPieceOwner will mint and sell a set of 10 black pixels at the price F1.0
  // TheMasterPieceUser1 will buy 5 pixels, colorize them white and sell a set of 3 pixels at the price F2.0
  // TheMasterPieceUser2 will buy 3 pixels to TheMasterPieceUser1

  const ownerSigner = [TMPOwner];
  const userSigner1 = [TMPUser1];
  const userSigner2 = [TMPUser2];

  // Minting 10 pixels by TheMasterPieceOwner at sector 0 with color 255 ( black )
  //const txMint = await getTransactionCode({ name: "Mint" , addressMap: { TheMasterPixelContract: TMPOwner}});
  console.log(`\nStep ${step++}`, "Pixels Minted", "@Owner");
  const argsMint = [0, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 255];
  try {
    const tx = await sendTransaction({name: "Mint", args: argsMint, addressMap: addressMap, signers: ownerSigner});
    console.log("Mint", { tx });
  } catch (e) {
    console.error(e);
  }

  // Enable marketplace
  console.log(`\nStep ${step++}`, "Market Opened", "@Owner");
  try {
    const tx = await sendTransaction({name: "OpenMarket", args: [true], addressMap: addressMap, signers: ownerSigner});
    console.log("InitPixels", { tx });
  } catch (e) {
    console.error(e);
  }

  // Selling 5 pixels by TheMasterPieceOwner at F1.0 on Sector 0
  console.log(`\nStep ${step++}`, "Pixels Sold", "@Owner");
  const argsSell = [0, 1.0, [0, 1, 2, 3, 4]];
  try {
    const tx = await sendTransaction({name: "Sell", args: argsSell, addressMap: addressMap, signers: ownerSigner});
    console.log("Sell", { tx });
  } catch (e) {
    console.error(e);
  }

  // Init pixels collection by TheMasterPieceUser1
  console.log(`\nStep ${step++}`, "Pixels collection initialized", "@User1");
  try {
    const tx = await sendTransaction({name: "InitPixels", args: [], addressMap: addressMap, signers: userSigner1});
    console.log("InitPixels", { tx });
  } catch (e) {
    console.error(e);
  }

  // Buying 5 pixels at sector 0 to TMPOwner by TheMasterPieceUser1
  console.log(`\nStep ${step++}`, "Pixels Bought", "@User1");
  const argsBuy = [0, TMPOwner, [0, 1, 2, 3, 4]];
  try {
    const tx = await sendTransaction({name: "Buy", args: argsBuy, addressMap: addressMap, signers: userSigner1});
    console.log("Buy", { tx });
  } catch (e) {
    console.error(e);
  }

  // Colorizing 5 pixels owned by TheMasterPieceUser1 at sector 0 to white (0)
  console.log(`\nStep ${step++}`, "Pixels Draw", "@User1");
  const argsDraw = [0, [0, 1, 2, 3, 4], 0];
  try {
    const tx = await sendTransaction({name: "Draw", args: argsDraw, addressMap: addressMap, signers: userSigner1});
    console.log("Draw", { tx });
  } catch (e) {
    console.error(e);
  }

  // Init marketplace by TheMasterPieceUser1
  console.log(`\nStep ${step++}`, "Pixels market initialized", "@User1");
  try {
    const tx = await sendTransaction({name: "InitMarket", args: [], addressMap: addressMap, signers: userSigner1});
    console.log("InitMarket", { tx });
  } catch (e) {
    console.error(e);
  }

  // Selling 3 pixels by TheMasterPieceUser1 on sector 0 at F2.0
  console.log(`\nStep ${step++}`, "Pixels Sold", "@User1");
  const argsSellUser = [0, 2.0, [0, 1, 2]];
  try {
    const tx = await sendTransaction({name: "Sell", args: argsSellUser, addressMap: addressMap, signers: userSigner1});
    console.log("Sell by User", { tx });
  } catch (e) {
    console.error(e);
  }

  // Init pixels collection by TheMasterPieceUser2
  console.log(`\nStep ${step++}`, "Pixels collection initialized", "@User2");
  try {
    const tx = await sendTransaction({name: "InitPixels", args: [], addressMap: addressMap, signers: userSigner2});
    console.log("InitPixels", { tx });
  } catch (e) {
    console.error(e);
  }

  // Buying 3 pixels at sector 0 to TheMasterPieceUser1 by TheMasterPieceUser2
  console.log(`\nStep ${step++}`, "Pixels Bought", "@User2");
  const argsBuy2 = [0, TMPUser1, [0, 1, 2]];
  try {
    const tx = await sendTransaction({name: "Buy", args: argsBuy2, addressMap: addressMap, signers: userSigner2});
    console.log("Buy", { tx });
  } catch (e) {
    console.error(e);
  }

  // Querying balances
  console.log(`\nStep ${step++}`, "Get Balances");
  try {
    const tx = await executeScript({name: "GetBalance", args: [TMPOwner], addressMap: addressMap});
    const tx1 = await executeScript({name: "GetBalance", args: [TMPUser1], addressMap: addressMap});
    const tx2 = await executeScript({name: "GetBalance", args: [TMPUser2], addressMap: addressMap});
    console.log("Balance ", { tx, tx1, tx2 });
  } catch (e) {
    console.error(e);
  }

  // Querying addresses owning Pixels
  console.log(`\nStep ${step++}`, "Get Pixels Owners");
  try {
    const tx = await executeScript({name: "GetOwners", args: [0], addressMap: addressMap});
    console.log("Owners ", { tx });
  } catch (e) {
    console.error(e);
  }

  // Querying pixels colors
  console.log(`\nStep ${step++}`, "Get Pixels Colors");
  try {
    const tx = await executeScript({name: "GetPixels", args: [0, TMPOwner], addressMap: addressMap});
    const tx1 = await executeScript({name: "GetPixels", args: [0, TMPUser1], addressMap: addressMap});
    const tx2 = await executeScript({name: "GetPixels", args: [0, TMPUser2], addressMap: addressMap});
    console.log("Colors ", { tx, tx1, tx2 });
  } catch (e) {
    console.error(e);
  }


  // Stop emulator instance
  await emulator.stop();
};

main();
