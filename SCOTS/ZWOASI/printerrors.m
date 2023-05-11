function printerrors(n)

if n==1
    error('no camera connected or index value out of boundary')
elseif n==2
    error('invalid ID')
elseif n==3
    error('invalid control type')
elseif n==4
    error('camera didnt open')
elseif n==5
    error('failed to find the camera, maybe the camera has been removed')
elseif n==6
    error('cannot find the path of the file')
elseif n==7
    error('INVALID_FILEFORMAT')
elseif n==8
    error('wrong video format size')
elseif n==9
    error('unsupported image format')
elseif n==10
    error('the startpos is out of boundary')
elseif n==11
    error('timeout')
elseif n==12
    error('stop capture first')
elseif n==13
    error('buffer size is not big enough')
elseif n==14
    error('VIDEO_MODE_ACTIVE')
elseif n==15
    error('EXPOSURE_IN_PROGRESS')
elseif n==16
    error('general error, eg: value is out of valid range')
elseif n==17
    error('the current mode is wrong')
end

