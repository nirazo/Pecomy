//
//  RichTag.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/17.
//  Copyright © 2016 Pecomy. All rights reserved.
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
            return R.image.card_able()
        case .CardDisable:
            return R.image.card_disable()
        case .SmokingEnable:
            return R.image.smoking_able()
        case .SmokingSeparated:
            return R.image.smoking_separated()
        case .SmokingDisabled:
            return R.image.smoking_disable()
        case .OnlyCounter:
            return R.image.seat_counter()
        case .HasCounter:
            return R.image.seat_counter()
        case .HasTable:
            return R.image.seat_table()
        case .StandingMeal:
            return R.image.style_standing_eat()
        case .StandingDrink:
            return R.image.style_standing_drink()
        case .Horigotatsu:
            return R.image.seat_horigotatsu()
        case .RaisedTatami:
            return R.image.seat_raised_tatami()
        case .TatamiRoom:
            return R.image.seat_tatami_room()
        case .Terrace:
            return R.image.seat_terrace()
        case .Sofa:
            return R.image.seat_sofa()
        case .CoupleSeat:
            return R.image.seat_couple_seat()
        case .WideSeat:
            return R.image.seat_wide_seat()
        case .PrivateRoom:
            return R.image.seat_private_room()
        case .Karaoke:
            return R.image.entertainment_karaoke()
        case .Sports:
            return R.image.entertainment_sports()
        case .Live:
            return R.image.entertainment_live()
        case .Darts:
            return R.image.entertainment_darts()
        case .Calm:
            return R.image.space_calm()
        case .Stylish:
            return R.image.space_stylish()
        case .Hiding:
            return R.image.space_hiding()
        case .SolitaryHouse:
            return R.image.space_solitary_house()
        case .BeautifulView:
            return R.image.space_beautiful_view()
        case .Hotel:
            return R.image.space_hotel()
        case .OceanView:
            return R.image.space_ocean_view()
        case .Fish:
            return R.image.particularity_fish()
        case .Vegetable:
            return R.image.particularity_vegetable()
        case .Healthy:
            return R.image.particularity_healty()
        case .Vegetarian:
            return R.image.particularity_vegetable()
        case .BarrierFree:
            return R.image.other_barrier_free()
        case .Sake:
            return R.image.drink_sake()
        case .Wine:
            return R.image.drink_wine()
        case .Cocktail:
            return R.image.drink_cocktail()
        case .Shochu:
            return R.image.drink_shochu()
        case .FreeDrink:
            return R.image.drink_free_drink()
        default:
            return R.image.seat_private_room()
        }
    }
}