//
//  RichTag.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/17.
//  Copyright © 2016年 Karuta. All rights reserved.
//

enum RichTag: String {
    // カード系
    case CardEnable = "カード使用可"
    case CardDisable = "カード仕様不可"
    // タバコ
    case SmokingEnable = "喫煙可"
    case SmokingSeparated = "分煙"
    case SmokingDisabled = "完全禁煙"
    // 座席系
    case OnlyCounter = "カウンターのみ"
    case HasCounter = "カウンター席あり"
    case HasTable = "テーブル席あり"
    // 座席のスタイル
    case StandingMeal = "立ち食い"
    case StandingDrink = "立ち飲み"
    // 座席の形
    case Horigotatsu = "掘りごたつあり"
    case RaisedTatami = "小上がりあり"
    case TatamiRoom = "座敷あり"
    case Terrace = "テラス席あり"
    case Sofa = "ソファー席あり"
    case CoupleSeat = "カップルシートあり"
    case WideSeat = "席が広い"
    // 個室
    case PrivateRoom = "個室あり"
    // エンターテインメント
    case Karaoke = "カラオケあり"
    case Sports = "スポーツ観戦可"
    case Live = "ライブ・生演奏あり"
    case Darts = "ダーツあり"
    // 空間系
    case Calm = "落ち着いた空間"
    case Stylish = "オシャレな空間"
    case Hiding = "隠れ家レストラン"
    case SolitaryHouse = "一軒家レストラン"
    case BeautifulView = "景色がきれい"
    case Hotel = "ホテルのレストラン"
    case OceanView = "海が見える"
    // こだわり系
    case Fish = "魚料理にこだわる"
    case Vegetable = "野菜料理にこだわる"
    case Healthy = "健康・美容メニューあり"
    case Vegetarian = "ベジタリアンメニューあり"
    // その他
    case BarrierFree = "バリアフリー"
    // Dring
    case Sake = "日本酒あり"
    case Wine = "ワインあり"
    case Cocktail = "カクテルあり"
    case Shochu = "焼酎あり"
    case FreeDrink = "飲み放題あり"
    
    // nothing
    case Nothing = "なし"
    
    func imageForTag() -> UIImage? {
        switch self {
        case .CardEnable:
            return UIImage(named: "card_able")
        case .CardDisable:
            return UIImage(named: "card_disable")
        case .SmokingEnable:
            return UIImage(named: "smoking_able")
        case .SmokingSeparated:
            return UIImage(named: "smoking_separated")
        case .SmokingDisabled:
            return UIImage(named: "smoking_disable")
        case .OnlyCounter:
            return UIImage(named: "seat_counter")
        case .HasCounter:
            return UIImage(named: "seat_counter")
        case .HasTable:
            return UIImage(named: "seat_table")
        case .StandingMeal:
            return UIImage(named: "style_standing_eat")
        case .StandingDrink:
            return UIImage(named: "style_standing_drink")
        case .Horigotatsu:
            return UIImage(named: "seat_horigotatsu")
        case .RaisedTatami:
            return UIImage(named: "seat_raised_tatami")
        case .TatamiRoom:
            return UIImage(named: "seat_tatami_room")
        case .Terrace:
            return UIImage(named: "seat_terrace")
        case .Sofa:
            return UIImage(named: "seat_sofa")
        case .CoupleSeat:
            return UIImage(named: "seat_couple_seat")
        case .WideSeat:
            return UIImage(named: "seat_wide_seat")
        case .PrivateRoom:
            return UIImage(named: "seat_private_room")
        case .Karaoke:
            return UIImage(named: "entertainment_karaoke")
        case .Sports:
            return UIImage(named: "entertainment_sports")
        case .Live:
            return UIImage(named: "entertainment_live")
        case .Darts:
            return UIImage(named: "entertainment_darts")
        case .Calm:
            return UIImage(named: "space_calm")
        case .Stylish:
            return UIImage(named: "space_stylish")
        case .Hiding:
            return UIImage(named: "space_hiding")
        case .SolitaryHouse:
            return UIImage(named: "space_solitary_house")
        case .BeautifulView:
            return UIImage(named: "space_beautiful_view")
        case .Hotel:
            return UIImage(named: "space_hotel")
        case .OceanView:
            return UIImage(named: "space_ocean_view")
        case .Fish:
            return UIImage(named: "particularity_fish")
        case .Vegetable:
            return UIImage(named: "particularity_vegetable")
        case .Healthy:
            return UIImage(named: "particularity_healty")
        case .Vegetarian:
            return UIImage(named: "particularity_vegetable")
        case .BarrierFree:
            return UIImage(named: "other_barrier_free")
        case .Sake:
            return UIImage(named: "drink_sake")
        case .Wine:
            return UIImage(named: "drink_wine")
        case .Cocktail:
            return UIImage(named: "drink_cocktail")
        case .Shochu:
            return UIImage(named: "drink_shochu")
        case .FreeDrink:
            return UIImage(named: "drink_free_drink")
        default:
            return UIImage(named: "seat_private_room")
        }
    }
}