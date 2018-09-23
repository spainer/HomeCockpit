cdef extern from "iowkit.h":
    # Basic type definitions
    ctypedef unsigned long ULONG
    ctypedef long LONG
    ctypedef unsigned short USHORT
    ctypedef unsigned short WORD
    ctypedef unsigned char UCHAR
    ctypedef unsigned char BYTE
    ctypedef char* PCHAR
    ctypedef unsigned short* PWCHAR
    ctypedef bint BOOL
    ctypedef unsigned char BOOLEAN
    ctypedef unsigned long DWORD
    ctypedef DWORD* PDWORD
    ctypedef void* PVOID
    ctypedef DWORD HANDLE
    ctypedef ULONG* PULONG
    ctypedef const char* PCSTR
    ctypedef const unsigned short* PWCSTR

    # IO-Warrior vendor & product IDs
    cdef ULONG IOWKIT_VENDOR_ID = 0x07c0
    cdef ULONG IOWKIT_VID = IOWKIT_VENDOR_ID
    # IO-Warrior 40
    cdef ULONG IOWKIT_PRODUCT_ID_IOW40 = 0x1500
    cdef ULONG IOWKIT_PID_IOW40 = IOWKIT_PRODUCT_ID_IOW40
    # IO-Warrior 24
    cdef ULONG IOWKIT_PRODUCT_ID_IOW24 = 0x1501
    cdef ULONG IOWKIT_PID_IOW24 = IOWKIT_PRODUCT_ID_IOW24
    # IO-Warrior PowerVampire
    cdef ULONG IOWKIT_PRODUCT_ID_IOWPV1 = 0x1511
    cdef ULONG IOWKIT_PID_IOWPV1 = IOWKIT_PRODUCT_ID_IOWPV1
    cdef ULONG IOWKIT_PRODUCT_ID_IOWPV2 = 0x1512
    cdef ULONG IOWKIT_PID_IOWPV2 = IOWKIT_PRODUCT_ID_IOWPV2
    # IO-Warrior 56
    cdef ULONG IOWKIT_PRODUCT_ID_IOW56 = 0x1503
    cdef ULONG IOWKIT_PID_IOW56 = IOWKIT_PRODUCT_ID_IOW56

    # Max number of pipes per IOW device
    cdef ULONG IOWKIT_MAX_PIPES = 2

    # pipe names
    cdef ULONG IOW_PIPE_IO_PINS = 0
    cdef ULONG IOW_PIPE_SPECIAL_MODE = 1

    # Max number of IOW devices in system
    cdef ULONG IOWKIT_MAX_DEVICES = 16
    # IOW Legacy devices open modes
    cdef ULONG IOW_OPEN_SIMPLE = 1
    cdef ULONG IOW_OPEN_COMPLEX = 2

    # first IO-Warrior revision with serial numbers
    cdef ULONG IOW_NON_LEGACY_REVISION = 0x1010

    # Report structure definitions
    ctypedef struct IOWKIT_REPORT:
        UCHAR ReportID
        DWORD Value
        BYTE Bytes[4]
    ctypedef struct IOWKIT40_IO_REPORT:
        UCHAR ReportID
        DWORD Value
        BYTE Bytes[4]
    ctypedef struct IOWKIT24_IO_REPORT:
        UCHAR ReportID
        WORD Value
        BYTE Bytes[2]
    ctypedef struct IOWKIT_SPECIAL_REPORT:
        UCHAR ReportID
        UCHAR Bytes[7]
    ctypedef struct IOWKIT56_IO_REPORT:
        UCHAR ReportID
        UCHAR Bytes[7]
    ctypedef struct IOWKIT56_SPECIAL_REPORT:
        UCHAR ReportID
        UCHAR Bytes[63]

    # Report pointer definitions
    ctypedef IOWKIT_REPORT* PIOWKIT_REPORT
    ctypedef IOWKIT40_IO_REPORT* PIOWKIT40_IO_REPORT
    ctypedef IOWKIT24_IO_REPORT* PIOWKIT24_IO_REPORT
    ctypedef IOWKIT_SPECIAL_REPORT* PIOWKIT_SPECIAL_REPORT
    ctypedef IOWKIT56_IO_REPORT* PIOWKIT56_IO_REPORT
    ctypedef IOWKIT56_SPECIAL_REPORT* PIOWKIT56_SPECIAL_REPORT

    # Report size definitions
    cdef ULONG IOWKIT_REPORT_SIZE = sizeof(IOWKIT_REPORT)
    cdef ULONG IOWKIT40_IO_REPORT_SIZE = sizeof(IOWKIT40_IO_REPORT)
    cdef ULONG IOWKIT24_IO_REPORT_SIZE = sizeof(IOWKIT24_IO_REPORT)
    cdef ULONG IOWKIT_SPECIAL_REPORT_SIZE = sizeof(IOWKIT_SPECIAL_REPORT)
    cdef ULONG IOWKIT56_IO_REPORT_SIZE = sizeof(IOWKIT56_IO_REPORT)
    cdef ULONG IOWKIT56_SPECIAL_REPORT_SIZE = sizeof(IOWKIT56_SPECIAL_REPORT)

    # IOWarrior handle
    ctypedef PVOID IOWKIT_HANDLE

    # Function declarations
    IOWKIT_HANDLE IowKitOpenDevice()
    void IowKitCloseDevice(IOWKIT_HANDLE devHandle)
    ULONG IowKitWrite(IOWKIT_HANDLE devHandle, ULONG numPipe, PCHAR buffer, ULONG length)
    ULONG IowKitRead(IOWKIT_HANDLE devHandle, ULONG numPipe, PCHAR buffer, ULONG length)
    ULONG IowKitReadNonBlocking(IOWKIT_HANDLE devHandle, ULONG numPipe, PCHAR buffer, ULONG length)
    BOOL IowKitReadImmediate(IOWKIT_HANDLE devHandle, PDWORD value)
    ULONG IowKitGetNumDevs()
    IOWKIT_HANDLE IowKitGetDeviceHandle(ULONG numDevice)
    BOOL IowKitSetLegacyOpenMode(ULONG legacyOpenMode)
    ULONG IowKitGetProductId(IOWKIT_HANDLE devHandle)
    ULONG IowKitGetRevision(IOWKIT_HANDLE devHandle)
    HANDLE IowKitGetThreadHandle(IOWKIT_HANDLE devHandle)
    BOOL IowKitGetSerialNumber(IOWKIT_HANDLE devHandle, PWCHAR serialNumber)
    BOOL IowKitSetTimeout(IOWKIT_HANDLE devHandle, ULONG timeout)
    BOOL IowKitSetWriteTimeout(IOWKIT_HANDLE devHandle, ULONG timeout)
    BOOL IowKitCancelIo(IOWKIT_HANDLE devHandle, ULONG numPipe)
    PCSTR IowKitVersion()