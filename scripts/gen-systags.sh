ctags -R --c-kinds=+pde --c++-kinds=+pde --fields=+iaS --extra=+q -f ~/.systags \
  $(xcrun --show-sdk-path)/usr/include \
  /opt/homebrew/include \
  /usr/local/include \
  $IDF_PATH/components
