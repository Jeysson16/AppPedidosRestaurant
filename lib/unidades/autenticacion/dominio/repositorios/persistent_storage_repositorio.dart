abstract class PersistentStorageRepositorio {
  Future<bool> isDarkMode();
  Future<void> updateDarkMode(bool isDarkMode);
}