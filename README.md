# Flutter-Shopping-App


What was implemented
->Provider package
For accessing data throughout a widget tree
->Image Picker(gallery and camera access)
->Firebase (Auth,Cloud,Firestore)
->http package (to get data from fakestoreapi)

Features
-> Fake admin priviledge account Pass@gmail.com ,password: Passerby
-> Admin can add new products or delete them
-> When a product is added it will be available to users on refreshing their screens
-> Adding product needs a image, price,name and description of the product.
-> Products can be deleted by swiping their icons(Cards).
-> Backend dev can retrieve any deleted product/remove any added product. 
-> Users need to have a password of minimum length 6 characters.
-> Users have a choice to use a email to create/login to their account or use google Sign In.
-> Displays User name on the drawer menu heading
-> Users can view the type of products on home screen( So it is possible to have multiple such categories if needed, but not implemented due to other fake prouct apis offering a 
different type of json, extractiion and modification can be done so that the format of this json can be converted into the standard model for the current app)
-> Clicking on the heading will redirect to a grid view of all products under the heading.
-> Clicking on any product will display more information like Price, a Description menu which appears on Tapping, a option to add the item in cart (Which can be pressed again to
remove it at the spot aside from doing so at the cart),a menu showing review(Which can only be read by a user unless user has brought the said product)
-> Reviews are updated in real time across all devices if any user adds a review to a product.
-> Allows each user to have a customisable profile picture which will appear when user gives a review. 
-> Cart menu on the top shows the total rounded down price of all its contents and allows the user to remve any item by swiping it.User can click the icon of the item to edit the
quantity of the item.
-> Ordered items can be viewed from the drawer.It contains the record of all items pruchsed by      the user.
-> User can use custom profile picture by clicking on Settings on top right(PS profile picture in reviews is dynamic) 
-> User can sign out through the drop down menu on the top right
-> Hero Animation along with a custom animation using a animation controller is used in the Repertoire of products under a heading(only one heading called 'Products' exists
currently) for creating a offset. Some buttons intercating with firebase have been stacked with CircularProgressIndicator so that the button shrinks in size and progress indicator
increases in size using a animation controller.
-> A animation switcher is used in Individual product view, Delete items menu and Cart.
