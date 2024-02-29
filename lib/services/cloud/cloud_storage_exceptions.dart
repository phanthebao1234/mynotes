class CloudStorageException implements Exception {
  const CloudStorageException();
}

// CRUD -> Create - Read - Update - Delete

// C
class CouldNotCreateNoteStorageException implements CloudStorageException {}

// R
class CouldNotGetAllNotesException implements CloudStorageException {}

// U
class CouldNotUpdateNoteException implements CloudStorageException {}

// D
class CouldNotDeleteNoteException implements CloudStorageException {}
