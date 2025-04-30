## 1. DNS

Thay vì gõ địa chỉ IP `142.250.71.174` thì ta gõ `google.com`. Đó là nhờ vào DNS (Domain Name System) đã giúp chúng ta dịch từ tên miền sang địa chỉ IP.

## 2. Tên miền

Khi mua 1 tên miền thì nhà bán sẽ cho chúng ta 2 thông tin để chỉnh sửa:

- Name Server: Sửa máy chủ DNS của tên miền (mặc định sẽ dùng máy chủ của nhà bán tên miền)
- Bản ghi DNS: Sửa các bản ghi DNS của tên miền theo máy chủ đó

> Tên miền dùng máy chủ DNS nào thì phải sửa các bản ghi DNS theo máy chủ DNS đó.

Ví dụ: Mình mua tên miền `duthanhduoc.com` bên `nhanhoa.com` thì mặc định họ sẽ dùng Name Server (máy chủ DNS) sau:

- DNS 1: `ns1.zonedns.vn`
- DNS 2: `ns2.zonedns.vn`

Mình muốn nối IP VPS của mình vào tên miền `duthanhduoc.com` thì mình phải sửa các bản ghi DNS bên zonedns.

Ví dụ dưới đây là bản ghi DNS tương ứng với name - type - value - TTL:

```
sub.example.com - A - 192.111.123.123 - 300
www.sub.example.com - A - 192.111.123.123 - 300
```

### Thay đổi Name Server của tên miền

> Thường thì mình không thích cách này. Vì nếu thay đổi VPS thì phải đổi lại Name Server và bản ghi DNS record, rất mất thời gian.

Một số nhà cung cấp VPS cung cấp luôn máy chủ DNS. Ví dụ Vultr:

- [ns1.vultr.com](http://ns1.vultr.com/)
- [ns2.vultr.com](http://ns2.vultr.com/)

Bạn có thể điền 2 thông số trên vào máy chủ DNS của tên miền. Lúc này các bản ghi DNS bên zonedns sẽ không có tác dụng nữa. Bạn phải vào Vultr để khai báo bản ghi DNS mới.

### Một số tips về tên miền

- Một tên miền có thể tạo vô hạn subdomain ([sub.example.com](http://sub.example.com), [sub2.example.com](http://sub2.example.com), ...), vì thế chúng ta thể mua 1 tên miền mà dùng cho rất nhiều dự án khác nhau. Ví dụ frontend của mình là `duthanhduoc.com` và backend là `api.duthanhduoc.com`
- Được ưu tiên chọn nhà cung cấp tên miền ở Việt Nam vì họ hỗ trợ tốt hơn (Tiếng Việt, và CSKH tốt). Được mua bên `nhanhoa.com`
- Không phải nhà cung cấp tên miền nào cũng hỗ trợ tên miền bạn muốn mua. Ví dụ `.vn` thì không mua được ở nhà cung cấp `namecheap.com`
- Change A record thì nên chờ 1p rồi mới truy cập lại, không thì có thể bị cache lên đến 2 ngày.
- Có thể dùng [https://dnschecker.org/](https://dnschecker.org/), [https://www.whois.com/whois](https://www.whois.com/whois) để kiểm tra máy chủ dns, bản ghi dns, người đăng ký tên miền,...
