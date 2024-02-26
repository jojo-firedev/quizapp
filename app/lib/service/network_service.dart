import 'dart:io';

class NetworkService {
  Future<String> getIpAddress() async {
    NetworkInterface interface = await getNetworkInterface();
    InternetAddress iPv4Address = interface.addresses
        .where((element) => element.type == InternetAddressType.IPv4)
        .first;
    return iPv4Address.address;
  }

  Future<NetworkInterface> getNetworkInterface() async {
    List<NetworkInterface> networkInterfaces = await NetworkInterface.list();
    return networkInterfaces.first;
  }
}
