# Jikan UI
UI for the Jikan api.

## TODO
Tasks to be done at some point.

### Before 1.0.0
- [ ] Style app
	- [ ] Use dark mode throughout the whole app
- [ ] testAnimeUpdatePod disposed sometimes after navigating back from anime details page
- [ ] sort animes in response like api
- [ ] animeSchedule pod disposed when in anime details

### Device testing 2024-01-17
- [ ] About/info page
- [ ] End of schedule other page 2 of 1. Should not be possible


### Future
- [ ] Hover/Focus color for select chips
- [ ] Splash screen
- [ ] Custom sort order of collections
- [ ] Custom anime portrait size
- [ ] Error log page
- [ ] Check if other image from api response should be used
- [ ] Producer page
	- [ ] Navigate from anime details to producer details page
	- [ ] Prodcer details page
		- [ ] Should contain summary
		- [ ] Should contain related animes
		- [ ] Navigate to anime details form producer details
- [ ] Verifiy that adjusting rate limit works.
- [ ] Refactor pod.dart
- [ ] Genre page like producer page
- [ ] Producer popup details from click on chip
- [ ] Blacklist. Like favorite but opposite. The blacklisted should be hidden in the results
	- [ ] Store in database
	- [ ] View blacklisted and edit page
- [ ] View individual anime episode details
- [ ] View previous seasons
- [ ] Recommendations in anime details page
- [ ] Share favorites between users
	In favorites toggle between me and other users...
- [ ] Toggle between light and dark mode

### Completed
- [x] year select current year should be max
- [x] Instance if jikan exception when searching for "map" in producers
- [x] Chipitem not clear if selected or not
- [x] Delete collections
- [x] Producer anime query search overflowing. When keyboard is up
- [x] Database resets after restarting app
- [x] Nicer apply button for query and settings
- [x] Anime not save when navigating back from details with device button
- [x] Make it clearer that clickling on genres will navigate
- [x] Geners says null animes
- [x] Anime detail title text somtimes overlaps with image. Make height dependent on image height
- [x] Reload collection page when new created
- [x] Move favorite button to GridTile header
- [x] Anime portrait too small. Subtitle too short
- [x] Make tabbar in anime details opaque
- [x] Producer details larger text
- [x] Clear notes in anime detail with 'x' at end of textfield
- [x] Hero animation between list and details
- [x] Producer popup overflowing 
- [x] Ref disposed when in detail view for too long
- [x] Producer and genres not stored in anime in favorites
- [x] Implement save score in notes
- [x] Implement textfield in notes
- [x] Remove question mark in notes
- [x] Liking anime in schedule page does not work
- [x] Add expiration to responses
- [x] Settings. Create settings page
	- [x] Set jikan api rate limit
	- [x] Cache expiration length
	- [x] Database section
		- [x] Drop database
		- [x] View database size
- [x] Favorites. Mark animes as favorite and view favorites in separate page
	- [x] Add functionality to heart button
	- [x] Create favorite page
- [x] Sorting results
	- [x] AnimeQuery add sorting field
	- [x] Anime query page add options for sorting
- [x] Store search for each page in database
	To prevent reloading to default query both when switching page
	and starting the app.
- [x] Schedule. View current season
	- [x] Create anime list where each day is separated as a page
	- [x] Adjust query page for schedule
		Other params than anime search
	- [x] Store last schedule query in database
	- [x] Fix: save anime from schedule
		Favorites does not get saved correctly
	- [x] Add sliver headline for each day

### Scrapped
<del>- [ ] Tags removed from animes

<del>- [ ] Fewer step to add tag

<del>- [ ] News page
	- [ ] Section for api news
		- [ ] Select which anime to watch for news updates
		- [ ] Just display news title
	- [ ] Section for airing anime episode release
		- [ ] Calculate when the episode should release and add a news post
			Start posting after anime been selections for news
		- [ ] Navigation item should get number overlay displaying number of unseen news
		- [ ] News should be fetched/calculated in the background
