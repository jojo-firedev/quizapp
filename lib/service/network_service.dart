import 'dart:io';

class NetworkService {
  Future<String> getIpAddress() async {
    NetworkInterface ipAddress = await getNetworkInterface();
    return ipAddress.addresses.first.address;
  }

  Future<NetworkInterface> getNetworkInterface() async {
    List<NetworkInterface> networkInterfaces = await NetworkInterface.list();
    return networkInterfaces.first;
  }
}
