class CurrentUser {
   static var USERID;
   static var NAME;
   static var AGE;
   static var PASSWORD;
   static var USER;
   static var QUOTE;

   static String whoCurrent(){
     return "current -> id: ${USERID}, name: ${NAME}, age: ${AGE}, password: ${PASSWORD}, user: ${USER},quote: ${QUOTE}";
   }
}