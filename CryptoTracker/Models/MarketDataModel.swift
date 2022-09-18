//
//  MarketDataModel.swift
//  CryptoTracker
//
//  Created by Alexis Schotte on 1/24/22.
//

import Foundation

/*
 
 URL: https://api.coingecko.com/api/v3/global
 
 JSON:
 {
   "data": {
     "active_cryptocurrencies": 12765,
     "upcoming_icos": 0,
     "ongoing_icos": 50,
     "ended_icos": 3375,
     "markets": 724,
     "total_market_cap": {
       "btc": 48187300.57505422,
       "eth": 703919617.5048451,
       "ltc": 15887044377.213327,
       "bch": 5861453273.736791,
       "bnb": 4628340812.781467,
       "eos": 774808646797.0608,
       "xrp": 2811119880734.7603,
       "xlm": 8935507391353.746,
       "link": 110090157340.56287,
       "dot": 97442527078.8238,
       "yfi": 72650466.34523462,
       "usd": 1697501975743.7932,
       "aed": 6234916269397.088,
       "ars": 177114864216206.8,
       "aud": 2367889641016.387,
       "bdt": 145786114042282.44,
       "bhd": 639890344776.3784,
       "bmd": 1697501975743.7932,
       "brl": 9255799272940.62,
       "cad": 2133878808648.2498,
       "chf": 1548308527095.6702,
       "clp": 1356236178540258.5,
       "cny": 10746715258236.36,
       "czk": 36522603759115.586,
       "dkk": 11156858895607.707,
       "eur": 1498911219601.5269,
       "gbp": 1252742878083.1135,
       "hkd": 13215553644248.25,
       "huf": 538020864524218.1,
       "idr": 24335133698966644,
       "ils": 5356518409518.799,
       "inr": 126645762462088.03,
       "jpy": 193019837580529.38,
       "krw": 2028196867968714.5,
       "kwd": 513022442113.2411,
       "lkr": 343515355679321.4,
       "mmk": 3016106536836645,
       "mxn": 34710162227092.2,
       "myr": 7113382029354.377,
       "ngn": 705312070921545.9,
       "nok": 15124856336509.574,
       "nzd": 2527712847036.616,
       "php": 87065719994381.05,
       "pkr": 298896765779686.2,
       "pln": 6786197011039.646,
       "rub": 131885956153714.83,
       "sar": 6367618486350.836,
       "sek": 15618990674138.69,
       "sgd": 2281841568363.956,
       "thb": 56017139126549.05,
       "try": 22704272255786.63,
       "twd": 46999587650908.22,
       "uah": 48029776137457.51,
       "vef": 169970872831.2261,
       "vnd": 38465942961642420,
       "zar": 25685326770473.27,
       "xdr": 1209504107756.9683,
       "xag": 69993659141.49602,
       "xau": 922015173.1449977,
       "bits": 48187300575054.22,
       "sats": 4818730057505422
     },
     "total_volume": {
       "btc": 2706498.502258745,
       "eth": 39536503.76243904,
       "ltc": 892315222.0422487,
       "bch": 329215671.2891442,
       "bnb": 259956406.1121299,
       "eos": 43518072543.348946,
       "xrp": 157889976323.2867,
       "xlm": 501873669680.9385,
       "link": 6183347944.373365,
       "dot": 5472978366.662679,
       "yfi": 4080502.041103505,
       "usd": 95342268608.21965,
       "aed": 350191675886.6485,
       "ars": 9947872344131.312,
       "aud": 132995409380.58946,
       "bdt": 8188254884520.807,
       "bhd": 35940221574.554375,
       "bmd": 95342268608.21965,
       "brl": 519863253813.17914,
       "cad": 119851905599.33466,
       "chf": 86962636620.24318,
       "clp": 76174658927223.03,
       "cny": 603602368331.7766,
       "czk": 2051336580240.1501,
       "dkk": 626638585903.8221,
       "eur": 84188176603.74403,
       "gbp": 70361831494.71724,
       "hkd": 742267687084.228,
       "huf": 30218597984145.598,
       "idr": 1366812461427144.8,
       "ils": 300855388861.2947,
       "inr": 7113213695944.252,
       "jpy": 10841194569599.34,
       "krw": 113916150519643.98,
       "kwd": 28814531103.31338,
       "lkr": 19293958876174.652,
       "mmk": 169403301848933.38,
       "mxn": 1949538591282.199,
       "myr": 399531776602.7451,
       "ngn": 39614712606715.26,
       "nok": 849506001231.234,
       "nzd": 141972074654.5905,
       "php": 4890152342023.082,
       "pkr": 16787901361121.084,
       "pln": 381155031039.8542,
       "rub": 7407535565164.62,
       "sar": 357645057735.09485,
       "sek": 877259658911.7423,
       "sgd": 128162414442.57005,
       "thb": 3146270933161.8154,
       "try": 1275213139599.9485,
       "twd": 2639789157432.3486,
       "uah": 2697650950116.649,
       "vef": 9546621355.74104,
       "vnd": 2160486596494482.5,
       "zar": 1442647701878.1235,
       "xdr": 67933273228.72871,
       "xag": 3931279224.4713726,
       "xau": 51786106.617240526,
       "bits": 2706498502258.745,
       "sats": 270649850225874.5
     },
     "market_cap_percentage": {
       "btc": 39.3018736762444,
       "eth": 16.934522560930525,
       "usdt": 4.637432977456592,
       "bnb": 3.6321838380659206,
       "usdc": 2.8243126007608805,
       "ada": 1.976603639711675,
       "xrp": 1.6986854300489862,
       "sol": 1.6294991557611604,
       "luna": 1.511360601373664,
       "dot": 1.1049195364500548
     },
     "market_cap_change_percentage_24h_usd": -2.8294202291681136,
     "updated_at": 1643013493
   }
 }
 
 */

struct GlobalData: Codable {
    let data: MarketDataModel
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd"}) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc"}) {
            return item.value.asPercentString()
        }
        return ""
    }
}
