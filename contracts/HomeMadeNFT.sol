//SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.4;

///@title This is an ERC721 compatible smart contract built from scratch.
///This smart contract also allows users to list their NFTs at a price and allow users to purchase NFTs as well.
///@author This contract is written by Vamsi Krishna (vamsi.mosalakanti@gmail.com)
contract HomeMadeNFT {
    uint256 tokenCounter = 1;

    ///@notice Event is emitted everytime a transfer happens
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    ///@notice Event is emitted everytime a NFT is listed
    event Listed(uint256 _price, uint256 _tokenId);

    ///@notice Event is emitted everytime someone buys a listed NFT
    event Purchased(uint256 _tokenId, uint256 _price);

    ///@notice This is the template of the NFTs that the user want to list
    ///@param price Selling value of the NFT
    ///@param seller Address of the seller
    struct Listing {
        uint256 price;
        address seller;
        bool exists;
    }

    //Maps addresses to the number of tokens each address is holding
    mapping(address => uint256) internal _balances;

    //Maps Token IDs to the addresses of their respective owners
    mapping(uint256 => address) internal _owners;

    //Maps the Token ID of the NFT to its URI
    mapping(uint256 => string) internal _tokenToURI;

    //Maps addresses to a map of all the corresponding approved addresses
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    //Maps the Token IDs to the addresses that are allowed to purchase
    mapping(uint256 => address) private _tokenApprovals;

    //Maps the Token ID to the details of the listed NFT
    mapping(uint256 => Listing) internal _listing;

    ///@notice Lists the NFT for sale
    ///@param price Selling price of the NFT
    ///@param tokenId ID of the NFT that you are going to list to sell
    function addListing(uint256 price, uint256 tokenId) public returns(bool) {
        require(ownerOf(tokenId) == msg.sender, "caller must be owner");
        _listing[tokenId] = Listing(price, msg.sender,true);
        emit Listed(price, tokenId);
        return true;
    }
///@notice Checks if an NFT is listed
///@param tokenId Token Id of the NFT
    function isListed(uint256 tokenId) public view returns(bool){
       return  _listing[tokenId].exists ;
    }

    ///@notice This function allows you to purchase the listed NFTs
    ///@param tokenId Id of the NFT you want to own
    function purchase(uint256 tokenId) external payable returns(bool){
        Listing memory item = _listing[tokenId];
        require(item.price != 0, "Not For Sale");
        require(msg.value == item.price, "Incorrect Funds");
        payable(item.seller).transfer(msg.value);
        _approve(msg.sender, tokenId);
        safeTransferFrom(item.seller, msg.sender, tokenId);
        addListing(0, tokenId);
        emit Purchased(tokenId, msg.value);
        return true;
    }

    ///@notice This function returns number of tokens an address is holding
    ///@param owner Address of the owner
    ///@return uint256 It returns number of tokens the account is holding
    function balanceOf(address owner) public view returns (uint256) {
        require(
            owner != address(0),
            "ERC721: address zero is not a valid owner"
        );
        return (_balances[owner]);
    }

    ///@notice This function returns the address of owner who owns the token
    ///@param tokenId ID of the NFT
    ///@return address Address of the owner
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }

    ///@notice This function transfers a NFT from owner to another given the conditions are
    ///satisfied such as the function is called by the owner or the transfer is approved
    ///through different means
    ///@param from Address of the owner
    ///@param to Address of the recipient
    ///@param tokenId ID of the NFT
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        require(
            _isApprovedOrOwner(from, tokenId) == true,
            "This transaction is either not approved or from address does not belong the owner"
        );
        require(
            ownerOf(tokenId) == from,
            "ERC721: transfer from incorrect owner"
        );
        require(to != address(0), "ERC721: transfer to the zero address");

        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    ///@notice Checks if the token is approved for the transfer
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        virtual
        returns (bool)
    {
        require(
            _exists(tokenId),
            "ERC721: operator query for nonexistent token"
        );
        address owner = ownerOf(tokenId);
        return (spender == owner ||
            isApprovedForAll(owner, spender) ||
            getApproved(tokenId) == spender);
    }

    ///@notice Sets approval for all the operator that can manage all the NFTs of the owner
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
    }

    ///@notice Approves the transfer to the recipient
    ///@param to Address of the recipient
    ///@param tokenId Token ID of the NFT
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
    }

    ///@notice Checks if the transfer of the tokenId is approved
    ///@param tokenId The ID of the NFT
    ///@return boolean Returns true or false depended upon the status of the approval
    function getApproved(uint256 tokenId) public view returns (address) {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );

        return _tokenApprovals[tokenId];
    }

    ///@notice Checks if the recipient is approved to manage all the  NFTs of the owner
    ///@param owner Address of the owner
    ///@param operator Address of the recipient
    ///@return boolean Returns true or false depended upon the status of the approval
    function isApprovedForAll(address owner, address operator)
        public
        view
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    //Checks if the given token is present on the chain
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function exists(uint256 tokenId) public view returns(bool){
        return _exists(tokenId);
    }

    ///@notice This function mints the NFT to the address that is calling this function
    ///@param uri  URI of the resource we are trying yo create NFT for
    ///@return uint256 Returns the ID of the NFT
    function mint(string memory uri) public returns (uint256) {
        uint256 tokenId = tokenCounter;
        _owners[tokenId] = msg.sender;
        _tokenToURI[tokenId] = uri;
        _balances[msg.sender] += 1;
        tokenCounter++;
        return (tokenId);
    }

    ///@notice Returns the URI of the NFT
    ///@param tokenId Token ID of the NFT
    ///@return string URI
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return (_tokenToURI[tokenId]);
    }
}
