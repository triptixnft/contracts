# TheMasterPiece

TheMasterPiece project is an 8K NFT composed of 33 177 600 pixels.
Each pixel is an NFT storing a color and its position (X,Y)

Pixels will be minted and distributed step by step, enabling a community of owners to contribute to TheMasterPiece and to join painting this picture through time.
The storage necessary to hold all the pixels will be distributed among the user community. The storage for a representative user holding 500 pixels, will be 98kB, costing only F0.001.

After a quarter of TheMasterPiece is distributed, a marketplace will be activated to authorize everyone to resell their pixels at the price they want.The exchange will be managed using the Flow token.

This project for the first time in the world of NFTs will enable
 - to display an 8k NFT
 - to purchase an NFT from 0.01F
 - to provide the liquidity of Fungible Token market to a Non Fungible Token market
 - to represent a whole crypto market as a unique constantly evolving piece of art.

# Smart Contracts
TheMasterPiece Flow smart contracts and js tests

High Performance, Low storage, Low computation:
NFT sold are represented by a single pixel (TheMasterPiecePixel), using 195 Bytes of memory.
Every contracts were designed to avoid useless computation.
1 000 000 pixels were already minted and exchanged on testnet with no impact, and no issue on every testnet spork.
The project has been running on testnet for more than 3 months without any issue.

Growing the Flow community:
We are expected to bring 320 000+ new Flow users while allowing anyone to enter the world of NFTs.
Typical holder are expected to hold an average of 90 pixels, for a storage of 17 KBytes.
Pixels will be minted one by one, through time, while the Flow blockchain will grow up and reach more users.

Fully On Chain, fully decentralized:
The web application only provides static webpage connecting directly all users to the Flow blockchain.
The only payment providers allowed are managed by the Flow fcl authentication (Blocto, upcoming Dappers and Ledger).
The only payment accepted will be using Flow token.


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


# License
SPDX-FileCopyrightText: 2021 copyright 52a74d3b580cdb48eb87979860ca6efe <creator@themasterpiece.art>
SPDX-License-Identifier: GPL-3.0-or-later
