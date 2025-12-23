# 🛡️ TrustSign

**TrustSign**, kimlik kartları ve pasaportların orijinalliğini doğrulamak için **Yapay Zeka (AI)** ve **Blokzincir (Blockchain)** teknolojilerini birleştiren hibrit bir iOS güvenlik uygulamasıdır.

Bu proje, belgelerin fiziksel analizini cihaz üzerinde (on-device) yaparken, doğrulama kayıtlarını değiştirilemez bir şekilde Ethereum blokzincirine işleyerek "Güvenin Dijital İmzasını" oluşturur.

---

## 🚀 Proje Hakkında

TrustSign, geleneksel manuel belge kontrolünün yavaş ve hataya açık doğasını, yapay zeka ve dağıtık defter teknolojisi ile çözmeyi hedefler.

### Temel Özellikler
* **🔍 Akıllı OCR ve MRZ Okuma:** Apple `Vision` Framework kullanılarak pasaport ve kimlik üzerindeki metinleri (Ad, Soyad, Doğum Tarihi) otomatik olarak ayrıştırır. Özellikle pasaportların altındaki **MRZ (Machine Readable Zone)** kodlarını okuyabilir.
* **🧠 AI Tabanlı Sahtecilik Tespiti:** Cihaz üzerinde çalışan `CoreML` modeli (`TrustSignModel.mlmodel`), belgenin dokusunu ve görsel özelliklerini analiz ederek "Gerçek" veya "Sahte" tahmini yapar.
* **🔗 Ethereum Blokzincir Kaydı:** Taranan belgenin benzersiz dijital parmak izini (Hash) oluşturur. Akıllı kontratlar aracılığıyla bu belgenin daha önce doğrulanıp doğrulanmadığını sorgular ve sonucu blokzincire mühürler.
* **🔒 Gizlilik Odaklı:** Biyometrik veriler ve tarama geçmişi, kullanıcının cihazında `CoreData` ile güvenli bir şekilde saklanır.

---

## 🛠️ Teknoloji Yığını

Proje %100 **Swift** ile geliştirilmiş olup aşağıdaki kütüphane ve framework'leri kullanmaktadır:

| Alan | Teknoloji / Kütüphane | Amaç |
| :--- | :--- | :--- |
| **UI** | SwiftUI | Modern ve reaktif kullanıcı arayüzü. |
| **AI & Vision** | Vision, CoreML | Görüntü işleme, metin tanıma (OCR) ve model çıkarımı. |
| **Blockchain** | [web3swift](https://github.com/web3swift-team/web3swift) | Ethereum ağı ile iletişim, cüzdan yönetimi ve işlem imzalama. |
| **Matematik** | [BigInt](https://github.com/attaswift/BigInt) | Blokzincir işlem ücretleri (Gas) ve büyük sayı hesaplamaları. |
| **Veri** | Core Data | Tarama geçmişinin yerel veritabanında saklanması. |

---

## ⚙️ Kurulum ve Çalıştırma

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları izleyin:

### 1. Depoyu Klonlayın
```bash
git clone [https://github.com/Dilara-Selin/TrustSign.git](https://github.com/Dilara-Selin/TrustSign.git)
cd TrustSign
```

### 2. Bağımlılıkları Yükleyin
Proje **Swift Package Manager (SPM)** kullanmaktadır. `TrustSign.xcodeproj` dosyasını Xcode ile açtığınızda, `web3swift` ve diğer paketler otomatik olarak indirilecektir.

### 3. Ortam Değişkenlerini Ayarlayın (Önemli!)
Proje güvenliği gereği API anahtarları ve Özel Anahtarlar (Private Keys) repoda bulunmamaktadır. Projenin ana dizinine (`TrustSign/`) `Secrets.swift` adında bir dosya oluşturun ve aşağıdaki şablonu doldurun:

```swift
// TrustSign/Secrets.swift

struct Secrets {
    // Infura, Alchemy veya kendi RPC URL'iniz (Örn: Sepolia Testnet)
    static let rpcURL = "[https://sepolia.infura.io/v3/YOUR_API_KEY](https://sepolia.infura.io/v3/YOUR_API_KEY)"
    
    // İşlemleri imzalayacak cüzdanın Private Key'i
    static let privateKey = "0xYOUR_PRIVATE_KEY"
    
    // Dağıtılmış Akıllı Kontrat Adresi
    static let contractAddress = "0xYOUR_CONTRACT_ADDRESS"
}
```

### 4. Çalıştırın
* Hedef cihaz olarak **Gerçek bir iPhone** seçmeniz önerilir (Kamera erişimi ve CoreML performansı için).
* Projeyi derleyin (`Cmd + B`) ve çalıştırın (`Cmd + R`).

---

## 📱 Kullanım Senaryosu

1. **Tarama:** Ana ekrandaki kamera butonu ile kimlik veya pasaportu çerçeveye alın.
2. **Analiz:** Uygulama otomatik olarak metinleri okuyacak ve yapay zeka analizi yapacaktır.
3. **Doğrulama:**
    * Eğer belge **Gerçek** ise ve blokzincirde kaydı yoksa, otomatik olarak kaydedilir (Gas ücreti ödenir).
    * Eğer daha önce kaydedilmişse, blokzincirdeki statüsü (Doğrulanmış/Şüpheli) gösterilir.
4. **Sonuç:** Analiz sonucu ve işlem hash'i (TxHash) ekranda belirir.
