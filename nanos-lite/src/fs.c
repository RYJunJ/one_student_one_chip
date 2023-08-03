#include <fs.h>

typedef size_t (*ReadFn) (void *buf, size_t offset, size_t len);
typedef size_t (*WriteFn) (const void *buf, size_t offset, size_t len);

typedef struct {
  char *name;
  size_t size;
  size_t disk_offset;
  ReadFn read;
  WriteFn write;
} Finfo;

enum {FD_STDIN, FD_STDOUT, FD_STDERR, FD_FB};

size_t invalid_read(void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

size_t invalid_write(const void *buf, size_t offset, size_t len) {
  panic("should not reach here");
  return 0;
}

static int *open_offset;

size_t serial_write(const void *, size_t, size_t);
size_t events_read(void *, size_t, size_t);

/* This is the information about all files in disk. */
static Finfo file_table[] __attribute__((used)) = {
  [FD_STDIN]  = {"stdin", 0, 0, invalid_read, invalid_write},
  [FD_STDOUT] = {"stdout", 0, 0, invalid_read, serial_write},
  [FD_STDERR] = {"stderr", 0, 0, invalid_read, serial_write},
  [FD_FB]     = {"/proc/fb", 0, 0, invalid_read, invalid_write},
  [3]         = {"/dev/events", 0, 0, events_read, invalid_write},
#include "files.h"
};

size_t ramdisk_read(void *, size_t, size_t);
size_t ramdisk_write(const void *, size_t, size_t);

char *get_file_table_name(int fd) {
  return file_table[fd].name;
}

int fs_open(const char *pathname, int flags, int mode) {
  //printf("pathname == %s\n", pathname);
  int file_cnt = sizeof(file_table) / sizeof(file_table[0]);
  for(int i = 0 ; i < file_cnt ; i++)
    if(!strcmp(file_table[i].name, pathname))
      return i;
  //assert(0);
  return -1;
}

size_t fs_read(int fd, void *buf, size_t len) {
  if(file_table[fd].read)
    return (file_table[fd].read)(buf, 0, len);
  if(open_offset[fd] < file_table[fd].size) {
    //printf("open_offset == %d, len == %d\n", open_offset[fd], len);
    if(open_offset[fd] + len <= file_table[fd].size) {
      ramdisk_read(buf, file_table[fd].disk_offset + open_offset[fd], len);
      open_offset[fd] += len;
      return len;
    }else {
      ramdisk_read(buf, file_table[fd].disk_offset + open_offset[fd], file_table[fd].size - open_offset[fd]);
      unsigned long tmp_len = file_table[fd].size - open_offset[fd];
      open_offset[fd] = file_table[fd].size;
      return tmp_len;
    }
  }
  return 0;
}

size_t fs_write(int fd, const void *buf, size_t len) {
  if(file_table[fd].write)
    return file_table[fd].write(buf, 0, len);
  if(open_offset[fd] + len <= file_table[fd].size) {
    ramdisk_write(buf, file_table[fd].disk_offset + open_offset[fd], len);
    open_offset[fd] += len;
    return len;
  }else {
    ramdisk_write(buf, file_table[fd].disk_offset + open_offset[fd], file_table[fd].size - open_offset[fd]);
    unsigned long tmp_len = file_table[fd].size - open_offset[fd];
    open_offset[fd] = file_table[fd].size;
    return tmp_len;
  }
  return 0;
}

size_t fs_lseek(int fd, size_t offset, int whence) {
  //printf("fs_lseek fd == %d, offset == %d, whence == %d\n", fd, offset, whence);
  assert(file_table[fd].read == NULL && file_table[fd].write == NULL);
  if(whence == SEEK_SET) {
    assert(0 <= offset);// && offset <= file_table[fd].size);
    open_offset[fd] = offset;
  }else if(whence == SEEK_CUR) {
    assert(0 <= open_offset[fd] + offset);// && open_offset[fd] + offset <= file_table[fd].size);
    open_offset[fd] += offset;
  }else if(whence == SEEK_END){
    assert(0 <= file_table[fd].size + offset);// && file_table[fd].size + offset <= file_table[fd].size);
    open_offset[fd] = file_table[fd].size + offset;
  }else {
    assert(0 <= whence && whence < 4);
  }
  return open_offset[fd];
}

int fs_close(int fd) {
  open_offset[fd] = 0;
  return 0;
}

void init_fs() {
  open_offset = (int *)malloc((sizeof(file_table) / sizeof(file_table[0])) * sizeof(int));
  // TODO: initialize the size of /dev/fb
}
