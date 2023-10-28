# Jikan UI
UI for the Jikan api.

## TODO
Tasks to be done at some point.

### Before 1.0.0
- [ ] Schedule. View current season
	- [x] Create anime list where each day is separated as a page
	- [ ] Adjust query page for schedule
		Other params than anime search
	- [ ] Store last schedule query in database
	- [ ] Fix: save anime from schedule
		Favorites does not get saved correctly
	- [ ] Add sliver headline for each day
- [ ] Settings. Create settings page
	- [ ] Set jikan api rate limit
	- [ ] Database section
		- [ ] Drop database
		- [ ] View database size
		- [ ] Drop individual collection
- [ ] News page
	- [ ] Section for api news
		- [ ] Select which anime to watch for news updates
		- [ ] Just display news title
	- [ ] Section for airing anime episode release
		- [ ] Calculate when the episode should release and add a news post
			Start posting after anime been selections for news
		- [ ] Navigation item should get number overlay displaying number of unseen news
		- [ ] News should be fetched/calculated in the background
- [ ] Style app
	- [ ] Use dark mode throughout the whole app
	- [ ] Hero animation between list and details
	- [ ] Check if other image from api response should be used
- [ ] Refactor pod.dart

### Future
- [ ] Blacklist. Like favorite but opposite. The blacklisted should be hidden in the results
	- [ ] Store in database
	- [ ] View blacklisted and edit page
- [ ] Producer page
	- [ ] Navigate from anime details to producer details page
	- [ ] Prodcer details page
		- [ ] Should contain summary
		- [ ] Should contain related animes
		- [ ] Navigate to anime details form producer details
- [ ] Genre page like producer page
- [ ] View individual anime episode details
- [ ] View previous seasons
- [ ] Recommendations in anime details page
- [ ] Share favorites between users
	In favorites toggle between me and other users...
- [ ] Toggle between light and dark mode



### Completed
- [x] Favorites. Mark animes as favorite and view favorites in separate page
	- [x] Add functionality to heart button
	- [x] Create favorite page
- [x] Sorting results
	- [x] AnimeQuery add sorting field
	- [x] Anime query page add options for sorting
- [x] Store search for each page in database
	To prevent reloading to default query both when switching page
	and starting the app.
