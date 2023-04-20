ffi.cdef[[
typedef struct _STARTUPINFOA {
  uint32_t  cb;
  void *    lpReserved;
  void *    lpDesktop;
  void *    lpTitle;
  uint32_t  dwX;
  uint32_t  dwY;
  uint32_t  dwXSize;
  uint32_t  dwYSize;
  uint32_t  dwXCountChars;
  uint32_t  dwYCountChars;
  uint32_t  dwFillAttribute;
  uint32_t  dwFlags;
  uint16_t  wShowWindow;
  uint16_t  cbReserved2;
  void *    lpReserved2;
  void **   hStdInput;
  void **   hStdOutput;
  void **   hStdError;
} STARTUPINFOA, *LPSTARTUPINFOA;
typedef struct _PROCESS_INFORMATION {
  void **  hProcess;
  void **  hThread;
  uint32_t dwProcessId;
  uint32_t dwThreadId;
} PROCESS_INFORMATION, *LPPROCESS_INFORMATION;
uint32_t CreateProcessA(
  void *,
  const char * evaLine,
  void *,
  void *,
  uint32_t,
  uint32_t,
  void *,
  const char * evaAttribute,
  LPSTARTUPINFOA,
  LPPROCESS_INFORMATION
);
uint32_t CloseHandle(void **);
]]

local function evalib_library:execeva(evaLine, evaAttribute)
   local si = ffi.new"STARTUPINFOA"
   si.cb = ffi.sizeof(si)
   local pi = ffi.new"PROCESS_INFORMATION"
   local success = ffi.C.CreateProcessA(nil, evaLine, nil, nil, 0, 0, nil, evaAttribute, si, pi) ~= 0
   if success then
      ffi.C.CloseHandle(pi.hProcess)
      ffi.C.CloseHandle(pi.hThread)
   end
   return success
end
