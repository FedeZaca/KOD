// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC1155 is ERC1155, Ownable {
    // Crear un mapping para almacenar la URL decodificadora de hash de cada NFT
    mapping(uint256 => string) public tokenURIs;

    // Crear un mapping para almacenar grupos de hash para 9 NFT
    mapping(uint256 => bytes32[]) public tokenGroups;

    // Crear un mapping para controlar la transferibilidad de los NFT
    mapping(uint256 => bool) public isTransferable;

    constructor() ERC1155("https://example.com/api/token/{id}.json") {
        // Establecer que ningún NFT sea transferible al desplegar el contrato
        isTransferable[0] = false;
        isTransferable[1] = false;
        isTransferable[2] = false;
        isTransferable[3] = false;
        isTransferable[4] = false;
        isTransferable[5] = false;
        isTransferable[6] = false;
        isTransferable[7] = false;
        isTransferable[8] = false;
        isTransferable[9] = false;
    }

    // Funcion para que el propietario (dueño del contrato) establezca la URL para un NFT
    function setTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
        tokenURIs[tokenId] = uri;
    }

    // Funcion para que el propietario establezca el grupo de hash para un grupo de NFT
    function setTokenGroup(uint256 tokenId, bytes32[] memory group) public onlyOwner {
        tokenGroups[tokenId] = group;
    }

    // Función para que el propietario cree nuevos NFT con un grupo de hash predefinido
    function mintWithGroup(uint256 tokenId, uint256 amount) public onlyOwner {
        require(tokenGroups[tokenId].length > 0, "Token group not set");
        _mint(msg.sender, tokenId, amount, "");
        isTransferable[tokenId] = false;
    }

    // Funcion para que el propietario cree nuevos NFT con una URL decodificadora de hash
    function mintWithURI(uint256 tokenId, uint256 amount, string memory uri) public onlyOwner {
        tokenURIs[tokenId] = uri;
        _mint(msg.sender, tokenId, amount, "");
        isTransferable[tokenId] = false;
    }

    // Funcion para quemar NFT (solo el propietario puede hacerlo)
    function burn(uint256 tokenId, uint256 amount) public onlyOwner {
        _burn(msg.sender, tokenId, amount);
    }

    // Funcion para permitir la transferencia de un NFT específico por el propietario
    function enableTransfer(uint256 tokenId) public onlyOwner {
        isTransferable[tokenId] = true;
    }

    // Funcion para deshabilitar la transferencia de un NFT específico por el propietario
    function disableTransfer(uint256 tokenId) public onlyOwner {
        isTransferable[tokenId] = false;
    }

    // Funcion para transferir un NFT (no permitida si isTransferable es falso)
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
        require(isTransferable[id], "Token not transferable");
        super.safeTransferFrom(from, to, id, amount, data);
    }
}
