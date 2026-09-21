# KỊCH BẢN QUAY VIDEO – ỨNG DỤNG PROFILE CÁ NHÂN
### Sinh viên: Nguyễn Hải Ninh

> **Cách đọc file này**
> - 🖥️ **LÀM:** thao tác trên màn hình.
> - 🎤 **NÓI:** câu bạn đọc to trong video.
> - Code trong file được **chép nguyên văn** từ project, có ghi **số dòng** để bạn mở đúng chỗ.
>
> **Chuẩn bị trước khi bấm quay:**
> - Mở Android Studio với project `bai4`.
> - Bật sẵn máy ảo **Pixel_7_API_34**.
> - Bấm thử mỗi nút 1 lần để bỏ qua các màn hình chào mừng của Chrome và YouTube.
>
> Video khoảng **7–9 phút**.

---

## MỞ ĐẦU (30 giây)

🖥️ **LÀM:** Màn hình Android Studio, cột Project bên trái đang mở.

🎤 **NÓI:**
> Em chào thầy, em là Nguyễn Hải Ninh. Hôm nay em xin trình bày bài tập "Xây dựng ứng dụng Profile cá nhân trên Android".
>
> Ứng dụng hiển thị ảnh đại diện, họ tên, ngành học và tiểu sử của em, nội dung em lấy từ CV của mình. Bên dưới có 3 nút để mở Facebook, YouTube và trang GitHub của em.
>
> Em viết bằng ngôn ngữ Java, giao diện bằng XML. Em sẽ trình bày lần lượt theo 4 yêu cầu của đề bài.

🖥️ **LÀM:** Chỉ vào từng file ở cột Project khi nói.

🎤 **NÓI:**
> Project của em có 3 file chính:
> - `activity_main.xml` trong thư mục `res/layout`: file giao diện.
> - `MainActivity.java`: file xử lý sự kiện.
> - `strings.xml` trong `res/values`: chứa nội dung chữ.
>
> Ngoài ra ảnh đại diện là file `avatar.png` trong thư mục `res/drawable`.

---

## YÊU CẦU 1 – THIẾT KẾ GIAO DIỆN XML: ImageView, TextView, Button (2 phút)

🖥️ **LÀM:** Mở `app/src/main/res/layout/activity_main.xml`. Bấm **Split** ở góc trên bên phải để thấy code bên trái, giao diện bên phải.

🎤 **NÓI:**
> Đầu tiên là phần giao diện. Giao diện em viết trong file `activity_main.xml`. Mỗi thẻ XML là một thành phần trên màn hình, và mỗi thành phần có các thuộc tính quy định id, kích thước, nội dung.

### 1.1. ImageView – ảnh đại diện · dòng 13 đến 22

🖥️ **LÀM:** Bôi đen dòng 13–22.

```xml
        <ImageView
            android:id="@+id/imgAvatar"
            android:layout_width="120dp"
            android:layout_height="120dp"
            android:layout_marginTop="32dp"
            android:src="@drawable/avatar"
            android:contentDescription="Ảnh đại diện"
            app:layout_constraintTop_toTopOf="parent"
            app:layout_constraintStart_toStartOf="parent"
            app:layout_constraintEnd_toEndOf="parent" />
```

🎤 **NÓI:**
> Để hiển thị ảnh đại diện, em dùng **ImageView**.
> - `id` là `imgAvatar`, là tên để phân biệt thành phần này.
> - `layout_width` và `layout_height` bằng 120dp nên ảnh là hình vuông 120dp. Đơn vị **dp** không phụ thuộc độ phân giải, nên trên máy nào ảnh cũng to như nhau.
> - `layout_marginTop` 32dp là khoảng cách với mép trên.
> - Thuộc tính quan trọng nhất là **`src`**: trỏ tới ảnh `avatar` trong thư mục drawable. Ảnh em đã cắt tròn sẵn nên hiện ra hình tròn.
> - `contentDescription` là mô tả ảnh, giúp trình đọc màn hình đọc cho người khiếm thị.
> - Ba dòng `constraint` cuối quy định vị trí, em sẽ giải thích ở yêu cầu 2.

### 1.2. TextView – thông tin cá nhân · dòng 25 đến 35

🖥️ **LÀM:** Bôi đen dòng 25–35.

```xml
        <TextView
            android:id="@+id/tvHoTen"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_marginTop="16dp"
            android:text="@string/ho_ten"
            android:textSize="24sp"
            android:textStyle="bold"
            app:layout_constraintTop_toBottomOf="@id/imgAvatar"
            app:layout_constraintStart_toStartOf="parent"
            app:layout_constraintEnd_toEndOf="parent" />
```

🎤 **NÓI:**
> Để hiển thị thông tin cá nhân, em dùng **TextView**. Đây là TextView họ tên, id là `tvHoTen`.
> - `wrap_content` nghĩa là khung chữ vừa đủ ôm nội dung.
> - **`text`** là nội dung hiển thị. Em không viết chữ trực tiếp mà dùng `@string/ho_ten`, tức là lấy chuỗi tên `ho_ten` trong file `strings.xml`.
> - `textSize` 24sp và `textStyle` bold để tên to và in đậm. Đơn vị **sp** dùng cho cỡ chữ, tự to nhỏ theo cài đặt cỡ chữ của người dùng.

🖥️ **LÀM:** Cuộn xuống, chỉ lướt dòng 38–47 và 50–60.

🎤 **NÓI:**
> Tương tự, em có thêm 2 TextView:
> - `tvLop` (dòng 38 đến 47) hiển thị ngành và trường.
> - `tvTieuSu` (dòng 50 đến 60) hiển thị tiểu sử. TextView này có thêm `gravity="center"` để căn giữa chữ.

🖥️ **LÀM:** Mở `app/src/main/res/values/strings.xml`, bôi đen dòng 5–7.

```xml
    <string name="ho_ten">Nguyễn Hải Ninh</string>
    <string name="lop">Kỹ thuật Phần mềm - Đại học Thủy Lợi</string>
    <string name="tieu_su">Fullstack Developer · Khóa 2023 - 2027\n\nMình thích xây dựng sản phẩm hoàn chỉnh, từ backend, frontend đến triển khai bằng Docker. Mình đã làm các dự án thực tế: hệ thống quản lý quy trình và KPI, hệ thống quản lý hồ sơ đấu thầu, và nền tảng tự động vẽ tuyến cáp viễn thông trên AutoCAD có ứng dụng AI.\n\nKỹ năng: Java, PHP, Python, C#, JavaScript · Laravel, Spring, React · MySQL, MariaDB · Git, Docker\nNgoại ngữ: Tiếng Anh B1\nEmail: haininh320@gmail.com</string>
```

🎤 **NÓI:**
> Đây là file `strings.xml` chứa nội dung chữ, em lấy từ CV của mình: ngành Kỹ thuật Phần mềm, định hướng Fullstack Developer, các dự án đã làm, kỹ năng và ngoại ngữ.
> - Ký hiệu **`\n`** là xuống dòng, em dùng để chia tiểu sử thành từng đoạn cho dễ đọc.
> - Để chữ ở file riêng thì muốn sửa chỉ cần sửa một chỗ, và sau này dễ làm thêm ngôn ngữ khác.

### 1.3. Button – các nút liên kết · dòng 63 đến 91

🖥️ **LÀM:** Quay lại `activity_main.xml`, bôi đen dòng 63–71.

```xml
        <Button
            android:id="@+id/btnFacebook"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_marginTop="24dp"
            android:text="@string/btn_facebook"
            app:layout_constraintTop_toBottomOf="@id/tvTieuSu"
            app:layout_constraintStart_toStartOf="parent"
            app:layout_constraintEnd_toEndOf="parent" />
```

🎤 **NÓI:**
> Cho các liên kết, em dùng **Button**. Đây là nút Facebook.
> - Thuộc tính quan trọng nhất là **`id`** `btnFacebook`. Bên code Java sẽ dùng id này để tìm nút và gắn sự kiện bấm.
> - `text` là chữ hiện trên nút.
> - `layout_width="0dp"` giúp nút co giãn theo màn hình, em giải thích ở yêu cầu 2.
>
> Nút YouTube (dòng 73 đến 81) và nút GitHub (dòng 83 đến 91) viết giống hệt, chỉ khác id là `btnYoutube`, `btnGithub` và chữ trên nút.
>
> Như vậy giao diện có đủ ImageView cho ảnh đại diện, TextView cho thông tin cá nhân và Button cho các liên kết.

---

## YÊU CẦU 2 – DÙNG ConstraintLayout TỐI ƯU CHO NHIỀU KÍCH THƯỚC MÀN HÌNH (2 phút)

### 2.1. Khung bố cục · dòng 2 đến 10

🖥️ **LÀM:** Cuộn lên đầu file, bôi đen dòng 2–10.

```xml
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <androidx.constraintlayout.widget.ConstraintLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:padding="16dp">
```

🎤 **NÓI:**
> Về bố cục, em dùng **ConstraintLayout** làm khung chứa tất cả thành phần.
> - `layout_width` là `match_parent` để khung rộng bằng màn hình.
> - `padding` 16dp để chừa lề, nội dung không dính sát mép.
>
> Bên ngoài em bọc thêm một **ScrollView**. Khi màn hình nhỏ hoặc xoay ngang, nội dung dài hơn màn hình thì người dùng vẫn cuộn xuống được, không bị mất nút nào.

### 2.2. Cách "neo" vị trí · dòng 20 đến 22

🖥️ **LÀM:** Bôi đen dòng 20–22 (trong ImageView).

```xml
            app:layout_constraintTop_toTopOf="parent"
            app:layout_constraintStart_toStartOf="parent"
            app:layout_constraintEnd_toEndOf="parent" />
```

🎤 **NÓI:**
> Trong ConstraintLayout, mỗi thành phần được **neo** vào cạnh màn hình hoặc vào thành phần khác. `parent` nghĩa là khung cha.
> - `constraintTop_toTopOf="parent"`: cạnh trên của ảnh neo vào cạnh trên khung.
> - `constraintStart_toStartOf="parent"`: cạnh trái neo vào cạnh trái.
> - `constraintEnd_toEndOf="parent"`: cạnh phải neo vào cạnh phải.
>
> Ảnh bị kéo đều từ cả hai bên, nên **luôn nằm chính giữa** dù màn hình rộng hay hẹp.

### 2.3. Xếp nối tiếp · dòng 33

🖥️ **LÀM:** Bôi đen dòng 33 (trong TextView họ tên).

```xml
            app:layout_constraintTop_toBottomOf="@id/imgAvatar"
```

🎤 **NÓI:**
> Dòng này nghĩa là cạnh trên của họ tên neo vào **cạnh dưới của ảnh**, nên tên luôn nằm ngay dưới ảnh.
>
> Các thành phần khác làm tương tự, mỗi cái neo vào cái phía trên nó: lớp dưới họ tên, tiểu sử dưới lớp, nút Facebook dưới tiểu sử, YouTube dưới Facebook, GitHub dưới YouTube. Vì vị trí tính **tương đối** chứ không phải tọa độ cố định, bố cục luôn đúng trên mọi màn hình.

### 2.4. Co giãn chiều rộng · dòng 65

🖥️ **LÀM:** Bôi đen dòng 65 và 69–71 (nút Facebook).

```xml
            android:layout_width="0dp"
```

🎤 **NÓI:**
> Các nút em đặt chiều rộng **0dp**. Trong ConstraintLayout, 0dp nghĩa là "rộng bằng khoảng cách giữa hai điểm neo". Nút neo vào cạnh trái và cạnh phải, nên luôn rộng hết màn hình:
> - Điện thoại nhỏ thì nút ngắn lại.
> - Máy tính bảng thì nút dài ra.
>
> TextView tiểu sử (dòng 52) cũng dùng 0dp, nên chữ tự xuống dòng vừa khít màn hình.

### 2.5. Demo co giãn trong Android Studio

🖥️ **LÀM:**
- Ở khung **Design** bên phải, bấm vào tên thiết bị trên thanh công cụ (ví dụ "Pixel") và chọn một máy tính bảng (**Medium Tablet**).
- Sau đó chọn lại điện thoại.
- Bấm nút **xoay** (Orientation) để xem khi xoay ngang.

🎤 **NÓI:**
> Em đổi thử sang màn hình máy tính bảng: ảnh và chữ vẫn ở giữa, các nút tự dài ra. Khi xoay ngang, bố cục vẫn đúng. Đây là lợi ích của ConstraintLayout.

---

## YÊU CẦU 3 – SỰ KIỆN CLICK + INTENT MỞ WEB / MẠNG XÃ HỘI (2 phút)

🖥️ **LÀM:** Mở `app/src/main/java/com/example/profileapp/MainActivity.java`.

Toàn bộ file:

```java
package com.example.profileapp;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Gắn file giao diện activity_main.xml vào màn hình
        setContentView(R.layout.activity_main);

        // Bước 1: Tìm các nút trong giao diện theo id
        Button btnFacebook = findViewById(R.id.btnFacebook);
        Button btnYoutube = findViewById(R.id.btnYoutube);
        Button btnGithub = findViewById(R.id.btnGithub);

        // Bước 2: Gắn sự kiện Click cho từng nút
        btnFacebook.setOnClickListener(v -> moLienKet("https://www.facebook.com"));
        btnYoutube.setOnClickListener(v -> moLienKet("https://www.youtube.com"));
        btnGithub.setOnClickListener(v -> moLienKet("https://github.com/HaiNinh1"));
    }

    // Bước 3: Dùng Intent để mở đường link
    private void moLienKet(String url) {
        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
        startActivity(intent);
    }
}
```

### 3.1. onCreate và setContentView · dòng 13 đến 16

🖥️ **LÀM:** Bôi đen dòng 13–16.

🎤 **NÓI:**
> Đây là file `MainActivity.java`, là màn hình chính của app.
>
> Hàm **`onCreate`** chạy đầu tiên khi màn hình được mở. Trong đó, `setContentView(R.layout.activity_main)` gắn file giao diện XML vừa rồi vào màn hình.
>
> `R` là class do Android tự sinh ra, chứa mã của tất cả tài nguyên. `R.layout.activity_main` là file giao diện, `R.id.btnFacebook` là id của nút.

### 3.2. Bước 1 – Tìm nút · dòng 19 đến 21

🖥️ **LÀM:** Bôi đen dòng 19–21.

🎤 **NÓI:**
> Xử lý Click gồm 3 bước.
>
> **Bước 1**, em dùng **`findViewById`** để tìm các nút theo id đã đặt bên XML. Ví dụ `findViewById(R.id.btnFacebook)` tìm nút có id `btnFacebook` và lưu vào biến. Đây là chỗ nối giao diện XML với code Java.

### 3.3. Bước 2 – Gắn sự kiện Click · dòng 24 đến 26

🖥️ **LÀM:** Bôi đen dòng 24–26.

🎤 **NÓI:**
> **Bước 2**, em gọi **`setOnClickListener`** để gắn sự kiện Click cho từng nút. Khi người dùng bấm nút, đoạn code sau dấu mũi tên sẽ chạy.
>
> Cách viết `v -> ...` là **lambda**, viết gọn thay cho tạo một đối tượng OnClickListener. `v` là nút vừa được bấm.
>
> Mỗi nút gọi hàm `moLienKet` với đường link riêng. Nút GitHub là trang cá nhân của em: `github.com/HaiNinh1`.

### 3.4. Bước 3 – Intent · dòng 30 đến 33

🖥️ **LÀM:** Bôi đen dòng 30–33.

🎤 **NÓI:**
> **Bước 3** là hàm `moLienKet`, nơi dùng **Intent**. Cả 3 nút dùng chung hàm này nên không phải viết lặp lại.
> - **Intent** là một "lời nhắn" gửi cho hệ điều hành Android để nhờ làm một việc.
> - Em tạo Intent với hành động **`ACTION_VIEW`**, nghĩa là "hãy mở nội dung này". Kèm theo là đường link, được `Uri.parse` chuyển từ chuỗi sang dạng Uri mà Android hiểu.
> - Cuối cùng **`startActivity(intent)`** gửi Intent đi.
>
> Đây là **Intent ngầm định**: em không chỉ định ứng dụng cụ thể, Android tự chọn ứng dụng phù hợp. Nếu máy đã cài app mạng xã hội, ví dụ YouTube, thì mở thẳng app. Nếu chưa cài thì mở bằng trình duyệt.

---

## YÊU CẦU 4 – CHẠY THỬ TRÊN TRÌNH GIẢ LẬP (2 phút)

### 4.1. Chạy app

🖥️ **LÀM:**
- Trên thanh công cụ Android Studio, chỉ vào ô chọn thiết bị đang hiện **Pixel_7_API_34**.
- Bấm nút **Run ▶** (tam giác xanh).
- Chờ app mở trên máy ảo.

🎤 **NÓI:**
> Tiếp theo em chạy thử trên trình giả lập. Em dùng máy ảo Pixel 7 chạy Android 14, tạo trong Device Manager của Android Studio.
>
> Em bấm Run. Android Studio build ứng dụng, cài lên máy ảo và mở app. Build thành công, không có lỗi.

### 4.2. Kiểm tra giao diện

🖥️ **LÀM:** Chỉ vào màn hình máy ảo.

🎤 **NÓI:**
> Ứng dụng hiển thị đúng như thiết kế: ảnh đại diện ở giữa, họ tên, ngành học, tiểu sử được chia đoạn, và 3 nút bên dưới.

### 4.3. Kiểm tra từng nút

🖥️ **LÀM:** Bấm lần lượt từng nút. Sau mỗi nút, bấm **Back** (vuốt từ cạnh trái vào, hoặc nút ◁) để quay lại app.

| Bấm | Kết quả trên máy ảo | 🎤 NÓI |
|---|---|---|
| **GitHub** | Chrome mở trang `github.com/HaiNinh1` | "Em bấm GitHub, trình duyệt mở đúng trang GitHub cá nhân của em." |
| **YouTube** | Mở **ứng dụng YouTube** (nếu máy ảo không có app YouTube thì mở Chrome, khi đó nói giống dòng Facebook) | "Em bấm YouTube. Máy ảo có sẵn app YouTube nên Android mở thẳng ứng dụng YouTube, đúng như Intent ngầm định em vừa giải thích." |
| **Facebook** | Chrome mở trang Facebook | "Máy ảo không có app Facebook nên Android mở bằng trình duyệt." |

### 4.4. Kiểm tra xoay màn hình

🖥️ **LÀM:**
- Trên thanh công cụ bên cạnh máy ảo, bấm nút **xoay** (Rotate left).
- Vuốt lên để cuộn xuống dưới.
- Xoay lại màn hình dọc.

🎤 **NÓI:**
> Em xoay ngang máy. Bố cục vẫn căn giữa, các nút tự dài ra theo chiều ngang. Màn hình ngang thấp hơn nên em cuộn xuống được nhờ ScrollView, vẫn thấy đủ 3 nút.

### 4.5. Kiểm tra lỗi trong Logcat

🖥️ **LÀM:** Mở tab **Logcat** ở dưới cùng Android Studio. Gõ `level:error` vào ô lọc.

🎤 **NÓI:**
> Em mở Logcat để kiểm tra lỗi. Trong suốt quá trình bấm thử, ứng dụng không bị dừng đột ngột và không có lỗi crash nào.

---

## KẾT LUẬN (30 giây)

🎤 **NÓI:**
> Tóm lại, em đã hoàn thành 4 yêu cầu của bài:
> 1. Thiết kế giao diện bằng XML, gồm **ImageView** cho ảnh đại diện, **TextView** cho thông tin cá nhân và **Button** cho các liên kết.
> 2. Dùng **ConstraintLayout** neo các thành phần tương đối với nhau, kết hợp chiều rộng 0dp và ScrollView, để bố cục hiển thị tốt trên nhiều kích thước màn hình.
> 3. Xử lý **sự kiện Click** bằng `setOnClickListener`, dùng **Intent ACTION_VIEW** để mở trang web hoặc ứng dụng mạng xã hội.
> 4. **Chạy thử trên máy ảo** Pixel 7: ứng dụng hoạt động đúng, không có lỗi.
>
> Em cảm ơn thầy đã xem.

---

## 📌 PHỤ LỤC – NẾU THẦY HỎI THÊM
*(Kiến thức để trả lời miệng, không có trong code.)*

| Câu hỏi | Trả lời |
|---|---|
| `dp` và `sp` khác nhau gì? | `dp` dùng cho kích thước, không phụ thuộc độ phân giải. `sp` dùng cho cỡ chữ, thay đổi theo cài đặt cỡ chữ của người dùng. |
| `wrap_content`, `match_parent`, `0dp`? | Vừa ôm nội dung / bằng khung cha / (trong ConstraintLayout) rộng theo 2 điểm neo. |
| ConstraintLayout khác LinearLayout thế nào? | LinearLayout chỉ xếp theo 1 hàng dọc hoặc ngang. ConstraintLayout neo tự do giữa các thành phần, linh hoạt hơn và không phải lồng nhiều layout. |
| Tại sao cần ScrollView? | Khi xoay ngang hoặc màn hình nhỏ, nội dung cao hơn màn hình. Không có ScrollView thì các nút dưới cùng bị che mất. |
| Intent là gì? Có mấy loại? | Lời nhắn yêu cầu Android làm một việc. **Tường minh** (explicit): chỉ rõ màn hình cần mở trong app mình. **Ngầm định** (implicit): chỉ nói hành động, Android tự chọn app. Bài này dùng ngầm định. |
| Không dùng lambda thì viết thế nào? | `btnFacebook.setOnClickListener(new View.OnClickListener() { public void onClick(View v) { moLienKet("..."); } });` Chạy giống hệt, lambda chỉ ngắn hơn. |
| Sao ảnh tròn? | Ảnh `avatar.png` đã được cắt tròn sẵn trước khi chép vào `drawable`. ImageView chỉ hiển thị ảnh đó. |
| Muốn mở email / gọi điện? | Đổi hành động Intent: `ACTION_SENDTO` với `mailto:...` để gửi mail, `ACTION_DIAL` với `tel:...` để mở màn hình quay số. |
