# @Transient

Properties that live on the class and are not columns.

Official reference: <https://developer.apple.com/documentation/swiftdata/transient()>

The thirteen screens are one meerschaum pipe, from a pit in Sepetçi to a counter in the Eskişehir bedesten. Each screen opens its own in-memory store.

On 2 April 2026 Kemal Aydın cuts lump EB-7 at Sepetçi, 180 grams, and says to avoid the grey seam. On 3 April Nesrin Kaya names the bowl lattice egg in Odunpazarı and counts 14 openings. On 4 April Yusuf Demir cooks wax lot WX-7 and whispers that it should run cooler than yesterday. On 5 April Halime Öztürk fits a cherry stem and sets the nick to tight on the tenon. On 6 April Nesrin keeps a lattice scratch the book cannot hold. On 7 April Cemil Arslan cuts an oxhide case, with three spare thongs and a stitch note. On 8 April Aylin Şahin files pipe EB-7 at 4000 lira in the bedesten and writes that Emre Yılmaz will collect at dusk. On 9 April she raises the price to 4500 and writes to hold it for Emre. On 10 April she reads the open card, which says the pipe is wrapped in newspaper. On 11 April Kemal cuts spare lump EB-8. On 12 April the wax card and the stem card are read in one book. On 13 April Halime tries the tenon at 16:00. On 14 April the four cards sit on Aylin's counter. Emre collects the pipe that evening.

## Examples (13 of 13 bottled)

01. [Sepetçi lump card](01-sepetci-lump/) — available
02. [Odunpazarı bowl](02-odunpazari-bowl/) — available
03. [Wax whisper](03-wax-whisper/) — available
04. [Stem nick](04-stem-nick/) — available
05. [Lattice scratch](05-lattice-scratch/) — available
06. [Hide case](06-hide-case/) — available
07. [Bedesten aside](07-bedesten-aside/) — available
08. [Bedesten price](08-bedesten-price/) — available
09. [Counter reading](09-counter-reading/) — available
10. [Twin lumps](10-twin-lumps/) — available
11. [Two benches](11-two-benches/) — available
12. [Trial hour](12-trial-hour/) — available
13. [Bedesten morning folder](13-bedesten-morning/) — available

## What each scenario adds

| Slot | Transient behavior |
| --- | --- |
| 01 | The seam note is absent from the schema. The lump code is a column |
| 02 | The open card keeps the count. A new context reads 0 |
| 03 | An optional transient needs no default. A new context reads nil |
| 04 | A non-optional transient needs a default. A new context reads it |
| 05 | A struct that is not a column can sit on `@Transient` |
| 06 | Two transient properties are both omitted, and both reset |
| 07 | Writing the aside does not mark the context changed |
| 08 | A stored price edit is filed. The aside stays on the open card |
| 09 | A fetch in the same context returns that card. A new context does not |
| 10 | Each open card keeps its own note. A new context defaults both |
| 11 | Each model omits its own transient property |
| 12 | A transient date comes back as its default |
| 13 | Four cards in one schema. Each aside is omitted and then read as its default |

`@Attribute(.ephemeral)` is a different mark. It stays in the schema, and `isTransient` on that attribute is false. `@Transient` is left out of the schema entirely.

See [CONTRIBUTING.md](../../CONTRIBUTING.md) before filling a later feature.
