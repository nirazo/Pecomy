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
    case SeparatedSmoking = "分煙"
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
            return UIImage(named: "third")
        case .SeparatedSmoking:
            return UIImage(named: "third")
        case .CardDisable:
            return UIImage(named: "third")
        case .SmokingEnable:
            return UIImage(named: "third")
        case .SmokingDisabled:
            return UIImage(named: "third")
        case .OnlyCounter:
            return UIImage(named: "third")
        case .HasCounter:
            return UIImage(named: "third")
        case .HasTable:
            return UIImage(named: "third")
        case .StandingMeal:
            return UIImage(named: "third")
        case .StandingDrink:
            return UIImage(named: "third")
        case .Horigotatsu:
            return UIImage(named: "third")
        case .RaisedTatami:
            return UIImage(named: "third")
        case .TatamiRoom:
            return UIImage(named: "third")
        case .Terrace:
            return UIImage(named: "third")
        case .Sofa:
            return UIImage(named: "third")
        case .CoupleSeat:
            return UIImage(named: "third")
        case .WideSeat:
            return UIImage(named: "third")
        case .PrivateRoom:
            return UIImage(named: "third")
        case .Karaoke:
            return UIImage(named: "third")
        case .Sports:
            return UIImage(named: "third")
        case .Live:
            return UIImage(named: "third")
        case .Darts:
            return UIImage(named: "third")
        case .Calm:
            return UIImage(named: "third")
        case .Stylish:
            return UIImage(named: "third")
        case .Hiding:
            return UIImage(named: "third")
        case .SolitaryHouse:
            return UIImage(named: "third")
        case .BeautifulView:
            return UIImage(named: "third")
        case .Hotel:
            return UIImage(named: "third")
        case .OceanView:
            return UIImage(named: "third")
        case .Fish:
            return UIImage(named: "third")
        case .Vegetable:
            return UIImage(named: "third")
        case .Healthy:
            return UIImage(named: "third")
        case .Vegetarian:
            return UIImage(named: "third")
        case .BarrierFree:
            return UIImage(named: "third")
        case .Sake:
            return UIImage(named: "third")
        case .Wine:
            return UIImage(named: "third")
        case .Cocktail:
            return UIImage(named: "third")
        case .Shochu:
            return UIImage(named: "third")
        case .FreeDrink:
            return UIImage(named: "third")
        default:
            return UIImage(named: "second")
        }
    }
}