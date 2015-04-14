/* Lozenge.js for Autocento of the breakfast table
 * Cause a#lozenge to link to random file in array
 * vim: fdm=marker
 */

function _randomize() {
    var randomlink = document.getElementById('randomizelink');
    // array with all files {{{
    var files=["about-the-author.html","about.html","about_author.html","abstract.html","amber-alert.html","and.html","angeltoabraham.html","apollo11.html","arspoetica.html","art.html","axe.html","big-dipper.html","boar.html","boy_bus.html","building.html","call-me-aural-pleasure.html","cereal.html","cold-wind.html","collage-instrument.html","creation-myth.html","deadman.html","death-zone.html","deathstrumpet.html","dollywood.html","dream.html","early.html","elegyforanalternateself.html","epigraph.html","ex-machina.html","exasperated.html","father.html","feedingtheraven.html","finding-the-lion.html","fire.html","found-typewriter-poem.html","hands.html","hard-game.html","hardware.html","howithappened.html","howtoread.html","hymnal.html","i-am.html","i-think-its-you.html","i-want-to-say.html","i-wanted-to-tell-you-something.html","in-bed.html","initial-conditions.html","january.html","joke.html","lappel-du-vide.html","largest-asteroid.html","last-bastion.html","last-passenger.html","leaf.html","leg.html","likingthings.html","listen.html","love-as-god.html","lovesong.html","man.html","manifesto_poetics.html","moon-drowning.html","moongone.html","mountain.html","movingsideways.html","music-433.html","no-nothing.html","notes.html","nothing-is-ever-over.html","on-genre-dimension.html","one-hundred-lines.html","onformalpoetry.html","options.html","ouroboros_memory.html","paul.html","peaches.html","philosophy.html","phone.html","planks.html","plant.html","poetry-time.html","prelude.html","problems.html","process.html","proverbs.html","punch.html","purpose-dogs.html","question.html","real-writer.html","reports.html","riptide_memory.html","ronaldmcdonald.html","roughgloves.html","sapling.html","seasonal-affective-disorder.html","sense-of-it.html","serengeti.html","shed.html","shipwright.html","sixteenth-chapel.html","snow.html","something-simple.html","spittle.html","squirrel.html","stagnant.html","statements-frag.html","stayed-on-the-bus.html","stump.html","swansong-alt.html","swansong.html","swear.html","table_contents.html","tapestry.html","telemarketer.html","the-night-we-met.html","the-sea_the-beach.html","theoceanoverflowswithcamels.html","time-looks-up-to-the-sky.html","todaniel.html","toilet.html","toothpaste.html","treatise.html","underwear.html","walking-in-the-rain.html","wallpaper.html","weplayedthosegamestoo.html","what-we-are-made-of.html","when-im-sorry-i.html","window.html","words-irritable-reaching.html","words-meaning.html","worse-looking-over.html","writing.html","x-ray.html","yellow.html"]
    // }}}

    var index = Math.floor(Math.random() * files.length);

    var url = window.location.pathname;
    var current = url.substring(url.lastIndexOf('/')+1);

    if (current != files[index]) {
        randomlink.setAttribute("href", files[index]);
        randomlink.setAttribute("title", "To random article");
    } else {
        _randomize()
    }
}

window.onload = function () {
    _randomize()
};
