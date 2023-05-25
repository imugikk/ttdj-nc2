//
//  RegionModel.swift
//  nc2-location
//
//  Created by Paraptughessa Premaswari on 23/05/23.
//

import Foundation
import MapKit

struct Region {
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
    let news: [News]
    let population: Int
}

struct News: Hashable, Equatable{
    let title: String
    let link: URL
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(link)
    }
}

let news1 = News(title: "Tepergok Curi Motor di Pamulang, 2 Maling Nyaris Diamuk Warga", link: URL(string: "https://megapolitan.kompas.com/read/2023/05/03/14233631/tepergok-curi-motor-di-pamulang-2-maling-nyaris-diamuk-warga")!)
let news2 = News(title: "Penusuk Pria hingga Tewas di Pamulang pada Malam Takbiran Jadi Tersangka", link: URL(string: "https://megapolitan.kompas.com/read/2023/05/02/16190441/penusuk-pria-hingga-tewas-di-pamulang-pada-malam-takbiran-jadi-tersangka")!)
let news3 = News(title: "Polsek Pamulang Gagalkan Rencana Tawuran Saat Sahur", link: URL(string: "https://megapolitan.kompas.com/read/2023/03/24/15550811/polsek-pamulang-gagalkan-rencana-tawuran-saat-sahur")!)

let news4 = News(title: "Duo Maling Motor di Pondok Aren Nekat Beraksi Siang Bolong, Arisan Keluarga Mendadak Bubar!", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)
let news5 = News(title: "Terjadi Pencopetan di Pondok Aren, Profil Maling No. 7 Bikin Geger!", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)

let news6 = News(title: "Balapan Liar di Serpong, Berikut Jenis Motor Yang Digunakan Pelaku", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)
let news7 = News(title: "Para Pelajar Ditangkap Akibat Tawuran yang Menewaskan 2 Semut", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)

let news8 = News(title: "Seorang Turis Kehilangan Handphone Setelah Menjualnya Kepada Pedagang di Ciputat Timur", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)
let news9 = News(title: "17 Penculikan Anak Kecil di Ciputat Timur, Akhirnya Terkuak!", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)

let news10 = News(title: "Ban Mobil Hilang di Ciputat, Para Warga Dihimbau untuk Berhati-hati", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)
let news11 = News(title: "Modus Berkenalan di Jalan Ciputat, Wanita Umur 31 Akhirnya Menikah", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)

let news12 = News(title: "Perampokan Gerbong KAI di Stasiun Serpong", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)
let news13 = News(title: "Serpong Berduka! 20 Pengguna Motor Luka-luka Akibat Pembegalan", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)

let news14 = News(title: "Babi Ngepet Bikin Resah! Warga Setu Dihimbau Menyimpang Uang di Bank", link: URL(string: "https://www.suara.com/news/2023/01/16/180835/duo-maling-motor-di-pondok-aren-nekat-beraksi-siang-bolong-arisan-keluarga-mendadak-bubar")!)

let pamulangRegion = Region(center: CLLocationCoordinate2D(latitude: -6.342050, longitude: 106.738147), radius: 5000, news: [news1, news2, news3], population: 368603)
let pondokArenRegion = Region(center: CLLocationCoordinate2D(latitude: -6.265253, longitude: 106.700901), radius: 5000, news: [news4, news5], population: 418420)
let serpongRegion = Region(center: CLLocationCoordinate2D(latitude: -6.309660, longitude: 106.680130), radius: 5000, news: [news6, news7], population: 199283)
let ciputatTimurRegion = Region(center: CLLocationCoordinate2D(latitude: -6.291398, longitude: 106.755760), radius: 5000, news: [news8, news9], population: 219261)
let ciputatRegion = Region(center: CLLocationCoordinate2D(latitude: -6.315077, longitude: 106.726285), radius: 5000, news: [news10, news11], population: 252262)
let serpongUtaraRegion = Region(center: CLLocationCoordinate2D(latitude: -6.251200,longitude: 106.662112), radius: 5000, news: [news12, news13], population: 197187)
let setuRegion = Region(center: CLLocationCoordinate2D(latitude: -6.342801, longitude: 106.673685), radius: 5000, news: [news14], population: 92980)

let regions: [Region] = [pamulangRegion, ciputatRegion, ciputatTimurRegion, serpongRegion, pondokArenRegion, serpongUtaraRegion, setuRegion]
