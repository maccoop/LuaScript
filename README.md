
# Tích hợp VoiceChat
Tài liệu hướng dẫn tích hợp tính năng Voicechat trong thư viện EFSDK vào Android project. 

# Server
## Setup
1. Thêm 2 sự kiện mới ở `TCPGameServerCmds`:
`CMD_KT_APPROVE_VC = 47001`
`CMD_KT_DISABLE_VC = 47002`

2. Thêm 3 properties mới trong `ServerConfig`:
```
public class ServerConfig
{
  ...
  /// Tencent Cloud AppID
  public string GMEAppID { get; set; }

  /// Tencent Cloud AuthKey
  public string GMEAuthKey { get; set; }

  /// Custom Room cho từng Server
  public string PrefixRoom { get; set; }
}
```
3. Trong file `ServerConfig.xml` và `ServerConfig.json` sẽ thêm các value tương tự 
```
<ServerConfig>
   <VoiceChat GMEAppID = "***Tencent AppID***" GMEAuthKey = "***Tencent AuthKey***" PrefixRoom = "custom-room-name"/>
</ServerConfig>
```
```
{
  ...
  "GMEAppID": "***Tencent AppID***",
  "GMEAuthKey": "***Tencent AuthKey***",
  "PrefixRoom": "custom-room-name"
}
```
4. Thêm data mới `VoiceChatInfo` để tương tác với `Client`
```
public class VoiceChatInfo
{
  /// ID của người chơi
  public int OpenID { get; set; }
  public string AppID { get; set; }
  public string AuthKey { get; set; }
  /// ID phòng chat
  public string RoomID { get; set; }
}
```
## Mô tả luồng
Khi `Server` nhận sự kiện `CMD_KT_CREATETEAM` hoặc `CMD_KT_AGREEJOINTEAM` có kết quả trả về `RESULT_OK`, `Server` sẽ tự động tạo `VoiceChatInfo` với  `OpenID` dựa theo `ID` của `Client`, RoomID = `PrefixRoom` + `TeamID`, và gửi về cho `Client` tại sự kiện `CMD_KT_APPROVE_VC` để `Client` khởi tạo và vào phòng chat voice.

Khi `Server` nhận sự kiện `CMD_KT_KICKOUTTEAMMATE` hoặc `CMD_KT_LEAVETEAM` có kết quả trả về `RESULT_OK`, `Server` sẽ tự đồng gửi sự kiện `CMD_KT_DISABLE_VC` để buộc `Client` thoát phòng chat voice

---

# CLIENT
## Setup
1. Import/Update thư viện `kv1-sdk-release.aar`
2. Thêm 2 sự kiện ở `TCPGameServerCmds` và tạo data `VoiceChatInfo` tương ứng với _Server_.
`CMD_KT_APPROVE_VC = 47001`
`CMD_KT_DISABLE_VC = 47002`
```
public class VoiceChatInfo
{
  /// ID của người chơi
  public int OpenID { get; set; }
  public string AppID { get; set; }
  public string AuthKey { get; set; }
  /// ID phòng chat
  public string RoomID { get; set; }
}
```
3. Thêm code trong `TcpCmdHandle` để xử lý dữ liệu nhận từ _Server_
```
switch(nID)
{
    ...
    case (int)TCPGameServerCmds.CMD_KT_APPROVE_VC:
    {
        ret = ProcessGameStreamCmd(client, nID, data, count);
        break;
    }
    case (int)TCPGameServerCmds.CMD_KT_DISABLE_VC:
    {
        ret = ProcessGameCmd(client, nID, data, count);
        break;
    }
}
```
4. Thêm code trong `PlayZone_Network` để xử lý yêu cầu từ Server
```
if (e.CmdID == (int)TCPGameServerCmds.CMD_KT_APPROVE_VC)
{
    KT_TCPHandler.VoiceChatApprove(e.bytesData, e.bytesData.Length);
}
else if (e.CmdID == (int)TCPGameServerCmds.CMD_KT_DISABLE_VC)
{
    KT_TCPHandler.VoiceChatDisable();
}
```
```
5. Trong `KT_TCPHandler`, thêm hàm `VoiceChatApprove` và `VoiceChatDisable` gọi đến SDK
```

## Luồng xử lý

-  `VoiceChatApprove`:
    - SetContext(Context context, string GMEAppId, GMEAuthKey); 
    - Init(int openID);
    - JoinRoom(string roomID, int Quality);
- `VoiceChatDisable`:
    - ExitRoom();
    - UnInit(int openID);

## Các hàm tương tác với SDK

<details>
<summary> package: vn.efun.efsdk.voicechat.GMEVoiceChatManager</summary>

```
// Setup SDK
void SetContext(Context context, string GMEAppId, GMEAuthKey);
```
```
//  Init User
//  @openID: ID người dùng nhận từ Server
//  return: check theo bảng mã lỗi
///
int Init(int openID);
```
```
// @openID: ID người dùng nhận từ Server
//  return: check theo bảng mã lỗi
int UnInit(int openID);
```
```
// @roomID: roomID nhận từ Server
// @quality: chất lượng âm thanh = {1,2,3}
//  return: check theo bảng mã lỗi
int JoinRoom(string roomID, int Quality);
int SwitchRoom(string roomID, int quality);
```
```
//  return: check theo bảng mã lỗi
int ExitRoom(); 
```
```
//  @active: trạng thái bật/tắt
//  return: check theo bảng mã lỗi
int EnableMic(bool active);
int EnableSpeaker(bool active);
```
```
//  return
//      0: Tắt
//      1: Bật
//      other: check theo bảng mã lỗi
int GetStateMic();
int GetStateSpeaker();
```
```
//  @idEffect: theo bảng mã VoiceEffect = {0, 1, ... , 12}
//  return: check theo bảng mã lỗi
int SetVoiceEffect(int idEffect);
```
```
// @quality: chất lượng âm thanh = {1,2,3}
//  return: check theo bảng mã lỗi
int ChangeQuality(int quality);
```
```
// Call Update
void Poll();
```
</details>

## Event các sự kiện
<details>
<summary> package: vn.efun.efsdk.voicechat.events</summary>

```
public interface QAVEndpointsUpdateInfo {
    void onEventTriggered(int eventID, String[] openIdList);
}

public interface QAVEnterRoomComplete {
    void onEventTriggered(int result, String error_info);
}

public interface QAVExitRoomComplete {
    void onEventTriggered();
}

public interface QAVRoomDisconnect {
    void onEventTriggered(int result, String error_info);
}
```
</details>

## Note: 
- Khi vào phòng thành công, mặc định SDK sẽ tắt mic và speaker, `EnableMic` và `EnableSpeaker`sẽ chỉ hoạt động chính xác khi có sự kiện `RegisterEnterRoomCompleleListener` trả về thông báo thành công.
- Khi gọi Init và nhận trả về thông báo thành công, cần gọi hàm `Poll` thông qua `Update` của Unity để VoiceChat hoạt động chính xác, và các `delegate` lắng nghe các sự kiện trả về
    - EnterRoomCompleleListener: khi vào phòng chat thành công
    - UpdateInfoListener: các sự kiện trong _voice chat room_
    - RoomDisconnectListener: khi không kết nối được với phòng chat
    - ExitRoomCompleleListener: khi rời phòng chat thành công
## Mã Lỗi Thường Gặp

| Tên lỗi                   | Mã lỗi    | Cách xử lý|
| :-                        | :-:       | :- |
| SUCCESS                   | 0         | Thành công|
| ERROR_NO_SETUP            | 2         | Gọi lại SetContext|
| ERROR_USER_INROOM         | 11        | User đã ở trong room, gọi lại ExitRoom|
| ERROR_USER_OUTROOM        | 12        | User không ở trong room, gọi lại JoinRoom|
| AV_ERR_HAS_IN_THE_STATE   | 1003      | User đã ở trong room, gọi lại ExitRoom|
| AV_ERR_TIMEOUT            | 1005      | Kiểm tra mạng hoặc cập nhật GMESDK|
| AV_ERR_NOT_IN_MAIN_THREAD | 1007      | Lỗi Polling, hoặc Polling khác thread với Context|
| AV_ERR_CONTEXT_NOT_START  | 1101      | Lỗi Polling, hoặc Polling khác thread với Context|
| AV_ERR_ROOM_NOT_EXIST     | 1201      | Join lại room / lỗi Polling|
| AV_ERR_ROOM_NOT_EXITED    | 1202      | Join lại room / lỗi Polling|
| AV_ERR_SDK_NOT_FULL_UPDATE| 7015      | Update GMESDK|
| AV_ERR_IN_OTHER_ROOM      | 7007      | Gọi lại ExitRoom|


