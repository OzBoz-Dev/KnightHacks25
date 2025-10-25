import 'package:fridgemagnets/models/magnet.dart';

class MagnetService {

  // GET magnets (localhost/api/magnets)
  // TODO: IMPLEMENT THIS FUNCTION
  Future<List<Magnet>> getMagnets({int fridgeId = 0}) async {
    return [];
  }

  // POST magnet data when placing or removing
  // TODO: IMPLEMENT THIS FUNCTION
  Future<void> placeOrUpdateMagnet(Magnet magnet) async {
  }

  // DELETE magnet data when a magnet is deleted
  // TODO: IMPLEMENT THIS FUNCTION
  Future<void> deleteMagnet(Magnet magnet) async {
  }

}