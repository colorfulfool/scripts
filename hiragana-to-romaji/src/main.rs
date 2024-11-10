use std::collections::HashMap;
use std::io::{self, Write};

fn hiragana_to_romaji(input: &str) -> String {
    // Hiragana to Romaji mapping with dakuten and handakuten characters included
    let map = HashMap::from([
        ("あ", "a"), ("い", "i"), ("う", "u"), ("え", "e"), ("お", "o"),
        ("か", "ka"), ("き", "ki"), ("く", "ku"), ("け", "ke"), ("こ", "ko"),
        ("が", "ga"), ("ぎ", "gi"), ("ぐ", "gu"), ("げ", "ge"), ("ご", "go"),
        ("さ", "sa"), ("し", "shi"), ("す", "su"), ("せ", "se"), ("そ", "so"),
        ("ざ", "za"), ("じ", "ji"), ("ず", "zu"), ("ぜ", "ze"), ("ぞ", "zo"),
        ("た", "ta"), ("ち", "chi"), ("つ", "tsu"), ("て", "te"), ("と", "to"),
        ("だ", "da"), ("ぢ", "ji"), ("づ", "zu"), ("で", "de"), ("ど", "do"),
        ("な", "na"), ("に", "ni"), ("ぬ", "nu"), ("ね", "ne"), ("の", "no"),
        ("は", "ha"), ("ひ", "hi"), ("ふ", "fu"), ("へ", "he"), ("ほ", "ho"),
        ("ば", "ba"), ("び", "bi"), ("ぶ", "bu"), ("べ", "be"), ("ぼ", "bo"),
        ("ぱ", "pa"), ("ぴ", "pi"), ("ぷ", "pu"), ("ぺ", "pe"), ("ぽ", "po"),
        ("ま", "ma"), ("み", "mi"), ("む", "mu"), ("め", "me"), ("も", "mo"),
        ("や", "ya"), ("ゆ", "yu"), ("よ", "yo"),
        ("ら", "ra"), ("り", "ri"), ("る", "ru"), ("れ", "re"), ("ろ", "ro"),
        ("わ", "wa"), ("を", "wo"), ("ん", "n")
    ]);

        // Convert each character in input string
    input.chars()
        .map(|c| map.get(&c.to_string()[..]).unwrap_or(&"").to_string()) // Convert each `&&str` to `String`
        .collect()
}

fn main() {
    let mut line = String::new();
    while io::stdin().read_line(&mut line).unwrap() != 0 {
        let line = std::mem::take(&mut line);
        let mut columns: Vec<String> = line.split('\t').map(|col| col.to_string()).collect();

        if columns.len() > 1 {
            columns[1] = hiragana_to_romaji(&columns[1]);
        }

        print!("{}", columns.join("\t"));
    }
}
