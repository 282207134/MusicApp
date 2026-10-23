class Track {
  const Track(
    this.id,
    this.title,
    this.artist,
    this.cover, {
    this.genre = 'Pop',
    this.year = 2020,
    this.plays = '12,598 Played',
  });
  final String id, title, artist, cover, genre, plays;
  final int year;
}

class Album {
  const Album(
    this.title,
    this.cover, {
    this.subtitle = 'Various Artists',
    this.count = 21,
  });
  final String title, cover, subtitle;
  final int count;
}

class Artist {
  const Artist(this.name, this.cover);
  final String name, cover;
}

abstract final class Catalog {
  static const tracks = [
    Track(
      'weapon',
      'Illegal Weapon 2.0',
      'Street Dancer 3D',
      'weapon',
      genre: 'Partyholics',
    ),
    Track(
      'freak',
      "I'm a Freak (feat. Pitbull)",
      'Enrique Iglesias',
      'concert',
      genre: 'Partyholics',
    ),
    Track(
      'forget',
      "Can't Remember To Forget",
      'Shakira',
      'guitar',
      genre: 'Partyholics',
    ),
    Track('beyonce', 'Beyonce', 'Beyonce', 'beyonce', genre: 'Partyholics'),
    Track(
      'roller',
      'Roller Coaster (Single)',
      'Justin Bieber',
      'live',
      genre: 'Partyholics',
    ),
    Track(
      'unconditionally',
      'Unconditionally',
      'Katy Perry',
      'acoustic',
      genre: 'Partyholics',
    ),
    Track('gully', 'Gully Boy', 'Ranvir Sing', 'loca', genre: 'Hip Hop'),
    Track(
      'gully-gully',
      'Gully Gully Mein Gully Boy',
      'Ranvir Sing',
      'guitar',
      genre: 'Hip Hop',
      plays: '1.5M Played',
    ),
    Track(
      'mere',
      'Mere Gully Mein',
      'Ranvir Sing',
      'country',
      genre: 'Hip Hop',
      plays: '3.7M Played',
    ),
    Track(
      'ashli',
      'Ashli Hip Hip',
      'Deep Purple',
      'concert',
      genre: 'Hip Hop',
      plays: '2.8M Played',
    ),
    Track(
      'apna',
      'Apna Time Aayega',
      'Arijit Sing',
      'color-show',
      genre: 'Hip Hop',
      plays: '6.1M Played',
    ),
    Track(
      'doori',
      'Doori',
      'Deep Purple',
      'surma',
      genre: 'Hip Hop',
      plays: '3M Played',
    ),
    Track('lahore', 'Lagli Lahore Di', 'Sreya Ghosal', 'singer'),
    Track('bezubaan', 'Bezubaan Kab Se', 'Kapal Dev', 'stage'),
    Track('nachi', 'Nachi Nachi', 'Sreya Ghoshal', 'festival'),
    Track('no-time', 'No Time To Die', 'Billie Eilish', 'guitar', year: 2019),
    Track('loca', 'Loca', 'Various Artists', 'loca', genre: 'Partyholics'),
  ];
  static const recommended = [
    Album('Baghi 3', 'baghi'),
    Album('Surma Surma', 'surma'),
    Album('Hindi Top 5', 'concert'),
  ];
  static const released = [
    Album('Baghi 3', 'singer'),
    Album('Baghi 3', 'country'),
  ];
  static const trendingAlbums = [
    Album('Akcent', 'akcent'),
    Album('Alicia Keys', 'alicia'),
    Album('Arash', 'arash'),
  ];
  static const albums = [
    Album('Geri - Inder Chahal', 'loca', count: 10),
    Album('Juada - Amercian', 'akcent', count: 23),
    Album('Bhoora - Pav Dharia', 'rock', count: 37),
    Album('Film - Munda', 'festival', count: 19),
    Album('Acoustic Sessions', 'acoustic', count: 12),
    Album('Live in Concert', 'beyonce', count: 18),
  ];
  static const searchAlbums = [
    Album('Gully Boy 2', 'saxophone'),
    Album('Gully Boy Unlimited', 'color-show'),
    Album('Hip Gully Boy', 'hip'),
  ];
  static const artists = [
    Artist('Justin Bieber', 'justin'),
    Artist('Michael Jackson', 'michael'),
    Artist('Sam Smith', 'sam'),
  ];
  static List<Track> get trending => tracks.sublist(1, 6);
  static List<Track> get topSongs => tracks.sublist(7, 12);
  static List<Track> get albumSongs => [
    tracks[6],
    tracks[10],
    tracks[0],
    ...tracks.sublist(12, 15),
  ];
  static Track byId(String id) =>
      tracks.firstWhere((t) => t.id == id, orElse: () => tracks.first);
  static List<Track> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return tracks
        .where(
          (t) =>
              '${t.title} ${t.artist} ${t.genre} ${t.genre == 'Hip Hop' ? 'Gully Boy' : ''}'
                  .toLowerCase()
                  .contains(q),
        )
        .toList();
  }
}
