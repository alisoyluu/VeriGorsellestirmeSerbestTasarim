# Veri setini yükleme,inceleme
# Veri setinde toplam 492105 adet veri girilmiş ve toplam 4 farklı değişken var.
# Bu değişkenlerden Values değişkeni numerik diğerleri ise kategorik değişkenlerdir.
# Ben facet_wrap() ile WhatIf-MOC-Nice metotlarının her birini ayrı bir grafik olarak yan yana görselleştireceğim. Böylece karşılaştırmak daha kolay olacak.
# Ders-2'de öğrendiğimiz görsel estetik dengesine göre min n-1 max n+1 estetik sayısını gözeteceğim.
# Burada bizim amacımız hangi yöntemin 'daha kaliteli' açıklama oluşturduğunu göstermek ve ayrıca modelden modele bu durumun değişip değişmediğini göstermek.
# Bu yüzden verilen metrik değerlerinin ortalamasını alarak bu ortalamalar üzerinden görselleştirme çalışmamı yapacağım.
# Bu hem veri kalabalığını azaltacak, amaca yönelik veriyi bir nevi filtrelemiş olacak, hem de görselleştirirken grafiklerimizin daha sade ve anlaşılır olmasını sağlayacak.
data <- read.csv("https://raw.githubusercontent.com/mcavs/data/main/results.csv")
View(data)

# Gerekli kütüphanelerin yüklenmesi ve çağrılması
install.packages("ggplot2")
library(ggplot2)

install.packages("dplyr")
library(dplyr)

# Veri setini düzenleme ve ortalama değerleri hesaplama
summary_data <- data %>%
group_by(CE_Method, Used_Model, Quality_Metric) %>% 
  summarise(mean_value = mean(Values))
            
View(summary_data)

# Grafik oluşturma
# Bu görselleştirme çalışmamda nokta grafikleri kullandım. Çünkü sütun grafiklerde 0 değerlerini göstermek imkansız.
# Verimizde de 0'a gidildikçe kalite metriğinin açıklama düzeyi mükemmele gitmekte.
# Dolayısıyla 0 değerini ön plana çıkarıp gösterebilmek için nokta grafiğini kullandım.
# Ayrıca bir veri manipülasyonu yaparak, 0'a doğru gittikçe metrik açıklama kalitesinin artacağını göz önünde bulundurarak, 0'a gidildikçe artan metrik kalitesi algısını destekleyecek şekilde Y eksenini terse çevirerek 6'dan 0'a doğru yükselecek şekilde değer sıralamasını yaptım. 
# Quality_Metric ve Mean değişkenlerini pozisyon estetiği ile gösterdim, ayrıca Used_Model değişkeni için renk estetiğini kullandım.
# Ayrıca face_wrap() fonksiyonunu kullanarak CE_Method değişkeninin her bir değeri için yan yana ayrı grafikler oluşturarak hem algılamayı hem de kıyaslamayı kolaylaştırdım.
# Grafiğin daha iyi anlaşılması için alta ufak bir not ekledim.

graphic <- ggplot(summary_data, aes(x = Quality_Metric, y = mean_value, color = Used_Model)) +
  geom_point(size = 4, position = position_dodge(width = 0.5)) +
  facet_wrap(~ CE_Method) +
  labs(title = "Quality Metrics Across Models by Counterfactual Explanation",
       x = "Quality Metric",
       y = "Average Value") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0.5)) +  # yatay hizala
  scale_y_reverse() +  # Y ekseni sınırlarını ayarla
  labs(caption = "***The quality of descriptions tends to improve towards '0' as the average value for the relevant metric decreases.")

# Grafik incelendiğinde NICE metodunun en kaliteli açıklamaları oluşturduğu tüm modeller için tutarlı bir biçimde gözlemlenmektedir.

ggsave("quality_metrics.png", plot = graphic, width = 8, height = 6, dpi = 300)