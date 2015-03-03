/* Lozenge.js for Autocento of the breakfast table
 * Cause a#lozenge to link to random file in array
 * TODO: manage to update array with filenames
 * vim: fdm=marker
 */

function lozenge() {
var lozenge = document.getElementById('lozenge');
// array with all files {{{
var files=["100-lines.html", "about-the-author.html", "amber-alert.html", "and.html", "angeltoabraham.html", "apollo11.html", "arspoetica.html", "art.html", "axe.html", "big-dipper.html", "boar.html", "boy_bus.html", "building.html", "call-me-aural-pleasure.html", "cereal.html", "cold-wind.html", "creation-myth.html", "deadman.html", "death-zone.html", "deathstrumpet.html", "dream.html", "early.html", "elegyforanalternateself.html", "epigraph.html", "ex-machina.html", "exasperated.html", "father.html", "feedingtheraven.html", "finding-the-lion.html", "fire.html", "found-typewriter-poem.html", "hands.html", "hard-game.html", "hardware.html", "howithappened.html", "howtoread.html", "hymnal.html", "i-am.html", "i-think-its-you.html", "i-wanted-to-tell-you-something.html", "in-bed.html", "index.html", "initial-conditions.html", "january.html", "joke.html", "lappel-du-vide.html", "largest-asteroid.html", "last-bastion.html", "last-passenger.html", "leaf.html", "leg.html", "likingthings.html", "listen.html", "love-as-god.html", "lovesong.html", "man.html", "moon-drowning.html", "moongone.html", "mountain.html", "movingsideways.html", "music-433.html", "no-nothing.html", "notes.html", "nothing-is-ever-over.html", "onformalpoetry.html", "options.html", "ouroboros_memory.html", "paul.html", "philosophy.html", "phone.html", "planks.html", "plant.html", "poetry-time.html", "prelude.html", "problems.html", "proverbs.html", "punch.html", "purpose-dogs.html", "question.html", "real-writer.html", "reports.html", "riptide_memory.html", "ronaldmcdonald.html", "roughgloves.html", "sapling.html", "seasonal-affective-disorder.html", "sense-of-it.html", "serengeti.html", "shed.html", "shipwright.html", "sixteenth-chapel.html", "snow.html", "something-simple.html", "spittle.html", "squirrel.html", "stagnant.html", "statements-frag.html", "stayed-on-the-bus.html", "stump.html", "swansong-alt.html", "swansong.html", "swear.html", "table_contents.html", "tapestry.html", "telemarketer.html", "the-night-we-met.html", "the-sea_the-beach.html", "theoceanoverflowswithcamels.html", "time-looks-up-to-the-sky.html", "todaniel.html", "toilet.html", "toothpaste.html", "treatise.html", "underwear.html", "wallpaper.html", "weplayedthosegamestoo.html", "when-im-sorry-i.html", "window.html", "words-meaning.html", "worse-looking-over.html", "writing.html", "x-ray.html", "yellow.html"]
// }}}

var index = Math.floor(Math.random() * files.length);

var url = window.location.pathname;
var current = url.substring(url.lastIndexOf('/')+1);

if (current != files[index]) {
    lozenge = lozenge.setAttribute("href", files[index]);
}
}

window.onload = function () {
    lozenge()
};
