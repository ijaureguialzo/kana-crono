package com.jaureguialzo.kanacrono.data

/**
 * Datos de los silabarios japoneses y lógica de selección aleatoria.
 * Réplica exacta de Silabarios.swift de la versión iOS.
 */

// MARK: - Datos de silabarios (exactamente como iOS)

val hiragana_basico = mapOf(
    "あ" to "a", "い" to "i", "う" to "u", "え" to "e", "お" to "o",
    "か" to "ka", "き" to "ki", "く" to "ku", "け" to "ke", "こ" to "ko",
    "さ" to "sa", "し" to "shi", "す" to "su", "せ" to "se", "そ" to "so",
    "た" to "ta", "ち" to "chi", "つ" to "tsu", "て" to "te", "と" to "to",
    "な" to "na", "に" to "ni", "ぬ" to "nu", "ね" to "ne", "の" to "no",
    "は" to "ha", "ひ" to "hi", "ふ" to "fu", "へ" to "he", "ほ" to "ho",
    "ま" to "ma", "み" to "mi", "む" to "mu", "め" to "me", "も" to "mo",
    "や" to "ya", "ゆ" to "yu", "よ" to "yo",
    "ら" to "ra", "り" to "ri", "る" to "ru", "れ" to "re", "ろ" to "ro",
    "わ" to "wa", "を" to "wo",
    "ん" to "n",
) // 46

val hiragana_tenten = mapOf(
    "が" to "ga", "ぎ" to "gi", "ぐ" to "gu", "げ" to "ge", "ご" to "go",
    "ざ" to "za", "じ" to "ji", "ず" to "zu", "ぜ" to "ze", "ぞ" to "zo",
    "だ" to "da", "ぢ" to "ji", "づ" to "zu", "で" to "de", "ど" to "do",
    "ば" to "ba", "び" to "bi", "ぶ" to "bu", "べ" to "be", "ぼ" to "bo",
    "ぱ" to "pa", "ぴ" to "pi", "ぷ" to "pu", "ぺ" to "pe", "ぽ" to "po",
) // 25

val hiragana_compuestos = mapOf(
    "きゃ" to "kya", "きゅ" to "kyu", "きょ" to "kyo",
    "しゃ" to "sha", "しゅ" to "shu", "しょ" to "sho",
    "ちゃ" to "cha", "ちゅ" to "chu", "ちょ" to "cho",
    "にゃ" to "nya", "にゅ" to "nyu", "にょ" to "nyo",
    "ひゃ" to "hya", "ひゅ" to "hyu", "ひょ" to "hyo",
    "みゃ" to "mya", "みゅ" to "myu", "みょ" to "myo",
    "りゃ" to "rya", "りゅ" to "ryu", "りょ" to "ryo",
    "ぎゃ" to "gya", "ぎゅ" to "gyu", "ぎょ" to "gyo",
    "じゃ" to "ja", "じゅ" to "ju", "じょ" to "jo",
    "びゃ" to "bya", "びゅ" to "byu", "びょ" to "byo",
    "ぴゃ" to "pya", "ぴゅ" to "pyu", "ぴょ" to "pyo",
) // 33

val katakana_basico = mapOf(
    "ア" to "a", "イ" to "i", "ウ" to "u", "エ" to "e", "オ" to "o",
    "カ" to "ka", "キ" to "ki", "ク" to "ku", "ケ" to "ke", "コ" to "ko",
    "サ" to "sa", "シ" to "shi", "ス" to "su", "セ" to "se", "ソ" to "so",
    "タ" to "ta", "チ" to "chi", "ツ" to "tsu", "テ" to "te", "ト" to "to",
    "ナ" to "na", "ニ" to "ni", "ヌ" to "nu", "ネ" to "ne", "ノ" to "no",
    "ハ" to "ha", "ヒ" to "hi", "フ" to "fu", "ヘ" to "he", "ホ" to "ho",
    "マ" to "ma", "ミ" to "mi", "ム" to "mu", "メ" to "me", "モ" to "mo",
    "ヤ" to "ya", "ユ" to "yu", "ヨ" to "yo",
    "ラ" to "ra", "リ" to "ri", "ル" to "ru", "レ" to "re", "ロ" to "ro",
    "ワ" to "wa", "ヲ" to "wo",
    "ン" to "n",
) // 46

val katakana_tenten = mapOf(
    "ガ" to "ga", "ギ" to "gi", "グ" to "gu", "ゲ" to "ge", "ゴ" to "go",
    "ザ" to "za", "ジ" to "ji", "ズ" to "zu", "ゼ" to "ze", "ゾ" to "zo",
    "ダ" to "da", "ヂ" to "ji", "ヅ" to "zu", "デ" to "de", "ド" to "do",
    "バ" to "ba", "ビ" to "bi", "ブ" to "bu", "ベ" to "be", "ボ" to "bo",
    "パ" to "pa", "ピ" to "pi", "プ" to "pu", "ペ" to "pe", "ポ" to "po",
) // 25

val katakana_compuestos = mapOf(
    "キャ" to "kya", "キュ" to "kyu", "キョ" to "kyo",
    "シャ" to "sha", "シュ" to "shu", "ショ" to "sho",
    "チャ" to "cha", "チュ" to "chu", "チョ" to "cho",
    "ニャ" to "nya", "ニュ" to "nyu", "ニョ" to "nyo",
    "ヒャ" to "hya", "ヒュ" to "hyu", "ヒョ" to "hyo",
    "ミャ" to "mya", "ミュ" to "myu", "ミョ" to "myo",
    "リャ" to "rya", "リュ" to "ryu", "リョ" to "ryo",
    "ギャ" to "gya", "ギュ" to "gyu", "ギョ" to "gyo",
    "ジャ" to "ja", "ジュ" to "ju", "ジョ" to "jo",
    "ビャ" to "bya", "ビュ" to "byu", "ビョ" to "byo",
    "ピャ" to "pya", "ピュ" to "pyu", "ピョ" to "pyo",
) // 33

val katakana_extra = mapOf(
    "ファ" to "fa", "フィ" to "fi", "フェ" to "fe", "フォ" to "fo",
    "ティ" to "ti", "トゥ" to "tu",
    "ディ" to "di", "ドゥ" to "du",
    "ヴァ" to "va", "ヴィ" to "vi", "ヴ" to "vu", "ヴェ" to "ve", "ヴォ" to "vo",
    "ウィ" to "wi", "ウェ" to "we", "ウォ" to "wo",
    "シェ" to "she",
    "チェ" to "che",
    "ジェ" to "je",
) // 19

// MARK: - Modelos de dominio

enum class Silabario {
    hiragana, katakana;

    companion object {
        val allValues = values()
    }
}

enum class Nivel {
    basico, tenten, compuestos, extra;

    companion object {
        val allValues = values()
    }
}

enum class Fuente {
    normal, cursiva;

    companion object {
        val allValues = values()
    }
}

// MARK: - Lógica de selección (exactamente como iOS)

/**
 * Devuelve un array de n tuplas del tipo (kana, romaji) extraídas del silabario seleccionado.
 * Sin repetición de lectura (romaji).
 */
fun tuplasKana(
    cantidad: Int = 1,
    silabario: Silabario = Silabario.hiragana,
    nivel: Nivel = Nivel.basico
): List<Pair<String, String>> {

    val result = mutableListOf<Pair<String, String>>()

    var i = 0
    while (i < cantidad) {
        val entry: Map.Entry<String, String>

        when (silabario) {
            Silabario.hiragana -> {
                val combined = when (nivel) {
                    Nivel.basico -> hiragana_basico
                    Nivel.tenten -> hiragana_basico + hiragana_tenten
                    Nivel.compuestos, Nivel.extra -> hiragana_basico + hiragana_tenten + hiragana_compuestos
                }
                entry = combined.entries.random()
            }
            Silabario.katakana -> {
                val combined = when (nivel) {
                    Nivel.basico -> katakana_basico
                    Nivel.tenten -> katakana_basico + katakana_tenten
                    Nivel.compuestos -> katakana_basico + katakana_tenten + katakana_compuestos
                    Nivel.extra -> katakana_basico + katakana_tenten + katakana_compuestos + katakana_extra
                }
                entry = combined.entries.random()
            }
        }

        // Si ya existe el valor romaji de la tupla, no añadirla
        if (!result.any { it.second == entry.value }) {
            result.add(entry.key to entry.value)
            i++
        }
    }

    return result
}
