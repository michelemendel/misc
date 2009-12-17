#include <qapplication.h>
#include <qpushbutton.h>

int main( int argc, char **argv )
{
   QApplication app( argc, argv );

   QLabel label( "Hello world!", 0 );
   label.resize( 150, 30 );

   app.setMainWidget( &hello );
   label.show();
   return app.exec();
}
