import "forge-std/Script.sol";
import "forge-std/Test.sol";

import "../src/BaitResponse.sol";

contract DeployBaitResponse is Script, Test {
  
    function run() external {
        vm.startBroadcast();
        BaitResponse _baitResponse = new BaitResponse();
        vm.stopBroadcast();
    }
}
