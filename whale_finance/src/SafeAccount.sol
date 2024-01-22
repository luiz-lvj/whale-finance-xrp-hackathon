// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interface/IERC6551Account.sol";
import "./interface/IV2SwapRouter.sol";
import "./WhaleFinance.sol";

contract SafeAccount is IERC165, IERC1271, IERC6551Account {
    receive() external payable {}

    IV2SwapRouter public swapRouter = IV2SwapRouter(0xb0744daaf6E84855C3551CDfbCec5892A8892B86);
    WhaleFinance public whaleFinance;


    function executeSwapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts){
        require(_isValidSigner(msg.sender), "Invalid signer");
        return swapRouter.swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);
    }

    
    function executeSwapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external virtual   returns (uint[] memory amounts) {
        require(_isValidSigner(msg.sender), "Invalid signer");
        return swapRouter.swapTokensForExactTokens(amountOut, amountInMax, path, to, deadline);
    }
    function executeSwapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        virtual
        
        payable
        
        returns (uint[] memory amounts)
    {
        require(_isValidSigner(msg.sender), "Invalid signer");
        return swapRouter.swapExactETHForTokens(amountOutMin, path, to, deadline);
    }
    function executeSwapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        virtual
        
        
        returns (uint[] memory amounts)
    {
        require(_isValidSigner(msg.sender), "Invalid signer");
        return swapRouter.swapTokensForExactETH(amountOut, amountInMax, path, to, deadline);
    }
    function executeSwapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        virtual
        
        
        returns (uint[] memory amounts)
    {
        require(_isValidSigner(msg.sender), "Invalid signer");
        return swapRouter.swapExactTokensForETH(amountIn, amountOutMin, path, to, deadline);
    }
    function executeSwapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        virtual
        
        payable
        
        returns (uint[] memory amounts)
    {
        require(_isValidSigner(msg.sender), "Invalid signer");
        return swapRouter.swapETHForExactTokens(amountOut, path, to, deadline);
    }



















    function executeApprove(address tokenErc20, address spender, uint256 amount) external returns (bool){
        require(_isValidSigner(msg.sender), "Invalid signer");
        
        return IERC20(tokenErc20).approve(spender, amount);
    }

    //Delegated Swaps Logic
    function setWhaleFinance(address _whaleFinance) external {
        require(msg.sender == _whaleFinance, "Invalid signer");
        whaleFinance = WhaleFinance(_whaleFinance);
    }

    function executeProposedSwap(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts){
        require(address(whaleFinance) != address(0), "Whale Finance not set");
        require(msg.sender == address(whaleFinance), "Invalid signer");

        return swapRouter.swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);
    }



    function isValidSignature(
        bytes32 hash,
        bytes memory signature
    ) external view returns (bytes4 magicValue) {
        bool isValid = SignatureChecker.isValidSignatureNow(
            owner(),
            hash,
            signature
        );

        if (isValid) {
            return IERC1271.isValidSignature.selector;
        }

        return "";
    }

    function token() public view returns (uint256, address, uint256) {
        bytes memory footer = new bytes(0x60);

        assembly {
            extcodecopy(address(), add(footer, 0x20), 0x4d, 0x60)
        }

        return abi.decode(footer, (uint256, address, uint256));
    }

    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();
        if (chainId != block.chainid) return address(0);

        return IERC721(tokenContract).ownerOf(tokenId);
    }

    function _isValidSigner(address signer) internal view returns (bool) {
        return signer == owner();
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external view override returns (bool) {}

    function executeCall(
        address to,
        uint256 value,
        bytes calldata data
    ) external payable override returns (bytes memory) {}

    function nonce() external view override returns (uint256) {}
}