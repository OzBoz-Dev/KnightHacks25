import 'package:fridgemagnets/models/magnet.dart';

class MagnetService {

  // GET magnets (localhost/api/magnets)
  // TODO: IMPLEMENT THIS FUNCTION
  Future<List<Magnet>> getMagnets({int fridgeId = 0}) async {
    return [];
  }


  // POST magnet data when placing a new magnet
  // TODO: IMPLEMENT THIS FUNCTION
  Future<void> placeMagnet(Magnet magnet) async {
  }

  // PUT magnet data when moving a magnet
  // TODO: IMPLEMENT THIS FUNCTION
  Future<void> updateMagnet(Magnet magnet) async {
  }

}