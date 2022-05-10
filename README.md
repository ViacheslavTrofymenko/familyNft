# Family NFT contract
The essence of this smart contract is that NFT man and NFT woman can create a NFT family.
And after that in this happy NFT family can be born a NFT child,
who inherits the geneus of the parents.
In fact, we have four separate ERC721 smart contracts that interact with each other: KidNft can be deploy only if exist familyNft contract, familyNft contract in turn can be deployed only if exists ManNft & WomanNft smart contracts.