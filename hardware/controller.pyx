cimport iowkit

cdef class Controller:
    cdef iowkit.IOWKIT_HANDLE _handle

    def __cinit__(self):
        self._handle = iowkit.IowKitOpenDevice()
        if self._handle is NULL:
            raise RuntimeError('Could not open IOWarrior')
        cdef iowkit.IOWKIT_SPECIAL_REPORT report
        cdef iowkit.ULONG res
        report.Bytes[0] = 0x01
        for i in range(1, 7):
            report.Bytes[i] = 0
        report.ReportID = 0x14
        res = iowkit.IowKitWrite(self._handle, iowkit.IOW_PIPE_SPECIAL_MODE, <iowkit.PCHAR>&report, iowkit.IOWKIT_SPECIAL_REPORT_SIZE)
        if res != iowkit.IOWKIT_SPECIAL_REPORT_SIZE:
            raise RuntimeError('Error during initialization of LED matrix')
        report.ReportID = 0x18
        res = iowkit.IowKitWrite(self._handle, iowkit.IOW_PIPE_SPECIAL_MODE, <iowkit.PCHAR>&report, iowkit.IOWKIT_SPECIAL_REPORT_SIZE)
        if res != iowkit.IOWKIT_SPECIAL_REPORT_SIZE:
            raise RuntimeError('Error during initialization of switch matrix')

    @property
    def productId(self):
        return iowkit.IowKitGetProductId(self._handle)
    
    @property
    def revision(self):
        return iowkit.IowKitGetRevision(self._handle)
    
    @property
    def serialNumber(self):
        cdef unsigned short serial[9]
        if not iowkit.IowKitGetSerialNumber(self._handle, serial):
            raise RuntimeError('Error during retrieving serial number')
        return serial
    
    @staticmethod
    def iowKitVersion():
        return iowkit.IowKitVersion()

    def __dealloc__(self):
        cdef iowkit.IOWKIT_SPECIAL_REPORT report
        cdef iowkit.ULONG res
        if self._handle is not NULL:
            for i in range(7):
                report.Bytes[i] = 0
            report.ReportID = 0x14
            res = iowkit.IowKitWrite(self._handle, iowkit.IOW_PIPE_SPECIAL_MODE, <iowkit.PCHAR>&report, iowkit.IOWKIT_SPECIAL_REPORT_SIZE)
            if res != iowkit.IOWKIT_SPECIAL_REPORT_SIZE:
                raise RuntimeError('Error during stopping of LED matrix')
            report.ReportID = 0x18
            res = iowkit.IowKitWrite(self._handle, iowkit.IOW_PIPE_SPECIAL_MODE, <iowkit.PCHAR>&report, iowkit.IOWKIT_SPECIAL_REPORT_SIZE)
            if res != iowkit.IOWKIT_SPECIAL_REPORT_SIZE:
                raise RuntimeError('Error during stopping of switch matrix')
            iowkit.IowKitCloseDevice(self._handle)
    
    def set_leds(self, values):
        cdef iowkit.IOWKIT_SPECIAL_REPORT report
        cdef iowkit.BYTE hw_val
        cdef unsigned char row, cell, pin
        report.ReportID = 0x15
        report.Bytes[5] = 0
        report.Bytes[6] = 0
        for row in range(8):
            report.Bytes[0] = row
            for cell in range(4):
                curr_vals = values[row][8*cell:8*(cell+1)]
                hw_val = 0
                for pin in range(8):
                    if curr_vals[pin]:
                        hw_val += 128 >> pin
                report.Bytes[cell+1] = hw_val
            iowkit.IowKitWrite(self._handle, iowkit.IOW_PIPE_SPECIAL_MODE, <iowkit.PCHAR>&report, iowkit.IOWKIT_SPECIAL_REPORT_SIZE)
    
    def get_switchmatrix(self):
        cdef iowkit.IOWKIT_SPECIAL_REPORT report
        cdef iowkit.ULONG res
        cdef unsigned char num, offset, line, pin
        status = [[None for i in range(8)] for j in range(8)]
        for num in range(2):
            res = iowkit.IowKitRead(self._handle, iowkit.IOW_PIPE_SPECIAL_MODE, <iowkit.PCHAR>&report, iowkit.IOWKIT_SPECIAL_REPORT_SIZE)
            if res != iowkit.IOWKIT_SPECIAL_REPORT_SIZE:
                raise RuntimeError('Error during reading of switch matrix')
            if report.ReportID == 0x19:
                offset = 0
            elif report.ReportID == 0x1A:
                offset = 4
            else:
                raise RuntimeError(f'Unknown Report ID: {report.ReportID}')
            for line in range(4):
                for pin in range(8):
                    status[offset+line][pin] = bool(report.Bytes[line] & (128 >> pin))
        return status

    def get_pins(self):
        cdef unsigned char port, pin
        cdef iowkit.ULONG res
        cdef iowkit.IOWKIT40_IO_REPORT report
        res = iowkit.IowKitRead(self._handle, iowkit.IOW_PIPE_IO_PINS, <iowkit.PCHAR>&report, iowkit.IOWKIT40_IO_REPORT_SIZE)
        if res != iowkit.IOWKIT40_IO_REPORT_SIZE:
            raise RuntimeError('Error during reading of I/O pins')
        return [
            [
                bool(report.Bytes[port] & (128 >> pin)) for pin in range(8)
            ] for port in range(4)
        ]