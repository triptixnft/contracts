# Smart Contracts
TheMasterPiece Flow smart contracts and js tests

High Performance, Low storage, Low computation:
NFT sold are represented by a single pixel (TheMasterPiecePixel), using 195 Bytes of memory
Every contracts were designed to avoid useless computation
1 000 000 pixels were already minted and exchanged on testnet with no impact, and no issue on every testnet spork
The project has been running on testnet for the past 3 monthes without any issue.

Growing the Flow community:
We are expected to bring 320 000+ new Flow users while allowing anyone to enter the world of NFTs.
Typical holder are expected to hold an average of 90 pixels, for a storage of 17 KBytes.
Pixels will be minted one by one, through time, while the Flow blockchain will grow up and reach more users.

Fully On Chain, fully decentralized:
The web application only provides static webpage connecting directly all users to the Flow blockchain
The only payment providers allowed are managed by the Flow fcl authentication (Blocto, upcoming Dappers and Ledger).
The only payment accepted will be using Flow token


# Running tests
1) deploying node modules

npm install

2) starting the test script

npm start


# Contracts
All contracts are located under /cadence/contracts

They have to be deployed in the following order

1. TheMasterPieceContract
2. TheMasterPixelContract
3. TheMasterMarketContract
