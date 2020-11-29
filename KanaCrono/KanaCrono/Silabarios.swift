//
//  Silabarios.swift
//  KanaCards
//
//  Created by Ion Jaureguialzo Sarasola on 26/09/2020.
//

import Foundation

// REF: Kana chart: https://en.wikibooks.org/wiki/Japanese/Kana_chart
// REF: Silabarios: https://mohayonao.hatenadiary.org/entry/20091129/1259505966

let hiragana_basico = [
    "あ": "a", "い": "i", "う": "u", "え": "e", "お": "o",
    "か": "ka", "き": "ki", "く": "ku", "け": "ke", "こ": "ko",
    "さ": "sa", "し": "shi", "す": "su", "せ": "se", "そ": "so",
    "た": "ta", "ち": "chi", "つ": "tsu", "て": "te", "と": "to",
    "な": "na", "に": "ni", "ぬ": "nu", "ね": "ne", "の": "no",
    "は": "ha", "ひ": "hi", "ふ": "fu", "へ": "he", "ほ": "ho",
    "ま": "ma", "み": "mi", "む": "mu", "め": "me", "も": "mo",
    "や": "ya", "ゆ": "yu", "よ": "yo",
    "ら": "ra", "り": "ri", "る": "ru", "れ": "re", "ろ": "ro",
    "わ": "wa", "を": "wo",
    "ん": "n",
]

let hiragana_tenten = [
    "が": "ga", "ぎ": "gi", "ぐ": "gu", "げ": "ge", "ご": "go",
    "ざ": "za", "じ": "ji", "ず": "zu", "ぜ": "ze", "ぞ": "zo",
    "だ": "da", "ぢ": "ji", "づ": "zu", "で": "de", "ど": "do",
    "ば": "ba", "び": "bi", "ぶ": "bu", "べ": "be", "ぼ": "bo",
    "ぱ": "pa", "ぴ": "pi", "ぷ": "pu", "ぺ": "pe", "ぽ": "po",
]

let hiragana_compuestos = [
    "きゃ": "kya", "きゅ": "kyu", "きょ": "kyo",
    "しゃ": "sha", "しゅ": "shu", "しょ": "sho",
    "ちゃ": "cha", "ちゅ": "chu", "ちょ": "cho",
    "にゃ": "nya", "にゅ": "nyu", "にょ": "nyo",
    "ひゃ": "hya", "ひゅ": "hyu", "ひょ": "hyo",
    "みゃ": "mya", "みゅ": "myu", "みょ": "myo",
    "りゃ": "rya", "りゅ": "ryu", "りょ": "ryo",
    "ぎゃ": "gya", "ぎゅ": "gyu", "ぎょ": "gyo",
    "じゃ": "ja", "じゅ": "ju", "じょ": "jo",
    "びゃ": "bya", "びゅ": "byu", "びょ": "byo",
    "ぴゃ": "pya", "ぴゅ": "pyu", "ぴょ": "pyo",
]

let katakana_basico = [
    "ア": "a", "イ": "i", "ウ": "u", "エ": "e", "オ": "o",
    "カ": "ka", "キ": "ki", "ク": "ku", "ケ": "ke", "コ": "ko",
    "サ": "sa", "シ": "shi", "ス": "su", "セ": "se", "ソ": "so",
    "タ": "ta", "チ": "chi", "ツ": "tsu", "テ": "te", "ト": "to",
    "ナ": "na", "ニ": "ni", "ヌ": "nu", "ネ": "ne", "ノ": "no",
    "ハ": "ha", "ヒ": "hi", "フ": "fu", "ヘ": "he", "ホ": "ho",
    "マ": "ma", "ミ": "mi", "ム": "mu", "メ": "me", "モ": "mo",
    "ヤ": "ya", "ユ": "yu", "ヨ": "yo",
    "ラ": "ra", "リ": "ri", "ル": "ru", "レ": "re", "ロ": "ro",
    "ワ": "wa", "ヲ": "wo",
    "ン": "n",
]

let katakana_tenten = [
    "ガ": "ga", "ギ": "gi", "グ": "gu", "ゲ": "ge", "ゴ": "go",
    "ザ": "za", "ジ": "ji", "ズ": "zu", "ゼ": "ze", "ゾ": "zo",
    "ダ": "da", "ヂ": "ji", "ヅ": "zu", "デ": "de", "ド": "do",
    "バ": "ba", "ビ": "bi", "ブ": "bu", "ベ": "be", "ボ": "bo",
    "パ": "pa", "ピ": "pi", "プ": "pu", "ペ": "pe", "ポ": "po",
]

let katakana_compuestos = [
    "キャ": "kya", "キュ": "kyu", "キョ": "kyo",
    "シャ": "sha", "シュ": "shu", "ショ": "sho",
    "チャ": "cha", "チュ": "chu", "チョ": "cho",
    "ニャ": "nya", "ニュ": "nyu", "ニョ": "nyo",
    "ヒャ": "hya", "ヒュ": "hyu", "ヒョ": "hyo",
    "ミャ": "mya", "ミュ": "myu", "ミョ": "myo",
    "リャ": "rya", "リュ": "ryu", "リョ": "ryo",
    "ギャ": "gya", "ギュ": "gyu", "ギョ": "gyo",
    "ジャ": "ja", "ジュ": "ju", "ジョ": "jo",
    "ビャ": "bya", "ビュ": "byu", "ビョ": "byo",
    "ピャ": "pya", "ピュ": "pyu", "ピョ": "pyo",
]

enum Silabario: String, CaseIterable, Identifiable {
    case hiragana
    case katakana

    var id: String { self.rawValue }
}

enum Nivel: String, CaseIterable, Identifiable {
    case basico
    case tenten
    case compuestos

    var id: String { self.rawValue }
}

/**
 Devuelve un array de n tuplas del tipo (kana: "あ", romaji: "a") extraidas del silabario seleccionado
 */
func kana(aleatorios: Int, _ silabario: Silabario = .hiragana, nivel: Nivel = .basico) -> [(String, String)] {

    var kana = [(kana: String, romaji: String)]()

    var i = 0
    while i < aleatorios {

        var aleatorio: Dictionary<String, String>.Element

        switch silabario {
        case .hiragana:
            switch nivel {
            case .basico:
                aleatorio = hiragana_basico
                    .randomElement()!
            case .tenten:
                aleatorio = hiragana_basico
                    .merging(hiragana_tenten, uniquingKeysWith: { (current, _) in current })
                    .randomElement()!
            case .compuestos:
                aleatorio = hiragana_basico
                    .merging(hiragana_tenten, uniquingKeysWith: { (current, _) in current })
                    .merging(hiragana_compuestos, uniquingKeysWith: { (current, _) in current })
                    .randomElement()!
            }
        case .katakana:
            switch nivel {
            case .basico:
                aleatorio = katakana_basico
                    .randomElement()!
            case .tenten:
                aleatorio = katakana_basico
                    .merging(katakana_tenten, uniquingKeysWith: { (current, _) in current })
                    .randomElement()!
            case .compuestos:
                aleatorio = katakana_basico
                    .merging(katakana_tenten, uniquingKeysWith: { (current, _) in current })
                    .merging(katakana_compuestos, uniquingKeysWith: { (current, _) in current })
                    .randomElement()!
            }
        }

        // Si ya existe el valor romaji de la tupla, no añadirla
        if !kana.contains(where: { $0.romaji == aleatorio.value }) {
            kana.append((kana: aleatorio.key, romaji: aleatorio.value))

            i += 1
        }
    }

    return kana
}
