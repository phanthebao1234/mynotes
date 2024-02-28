class CloudStorageException implements Exception {
  const CloudStorageException();
}

// CRUD -> Create - Read - Update - Delete

// C
class CouldNotCreateNoteStorageException implements CloudStorageException {}

// R
class CouldNotGetAllNotesStorage implements CloudStorageException {}

// U
class CouldNotUpdateNoteStorage implements CloudStorageException {}

// D
class CouldNotDeleteNoteStorage implements CloudStorageException {}
