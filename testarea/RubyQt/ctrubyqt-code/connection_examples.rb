#---
# Excerpted from "Rapid GUI Development with QtRuby"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com for more book information.
#---


@button = Qt::PushButton.new
@lineedit = Qt::LineEdit.new
Qt::Object::connect( @button, SIGNAL( 'clicked()' ), 
  @lineedit, SLOT( 'clear()' ) )



@lineedit = Qt::LineEdit.new
@label = Qt::Label.new
Qt::Object::connect( @lineedit, 
   SIGNAL( 'textChanged(const QString &)' ), 
   @label, 
   SLOT( 'setText(const QString &)' ) )



@lineedit_1 = Qt::LineEdit.new
@lineedit_2 = Qt::LineEdit.new
@label = Qt::Label.new
Qt::Object::connect( @lineedit_1, 
   SIGNAL( 'textChanged(const QString &)' ),
   @label, 
   SLOT( 'setText(const QString &)' ) )
Qt::Object::connect( @lineedit_1, 
   SIGNAL( 'textChanged(const QString &)' ), 
   @lineedit_2, 
   SLOT( 'setText(const QString &)' ) )



@lineedit_1 = Qt::LineEdit.new
@lineedit_2 = Qt::LineEdit.new
@label = Qt::Label.new
Qt::Object::connect( @lineedit_1, 
   SIGNAL( 'textChanged(const QString &)'  ), 
   @lineedit_2, 
   SIGNAL( 'textChanged(const QString &)' ) )
Qt::Object::connect( @lineedit_2, 
   SIGNAL( 'textChanged(const QString &)' ), 
   @label, 
   SLOT( 'setText(const QString &)' ) )



@lineedit = Qt::LineEdit.new
@bar = Qt::StatusBar.new
Qt::Object::connect( @lineedit, 
   SIGNAL( 'textChanged(const QString &)' ),  
   @bar, 
   SLOT( 'clear()' ) )  



@button = Qt::PushButton.new
@label = Qt::Label.new

# This doesn't work
Qt::Object::connect( @button, SIGNAL( 'clicked()' ),  
   @label, SLOT( 'setText(const QString &)' ) )  



@button = Qt::PushButton.new
@bar = Qt::StatusBar.new
Qt::Object::connect( @button, SIGNAL( 'clicked()' ), 
   @bar, SLOT( 'clear()' ) )
# Perform a disconnection
Qt::Object::disconnect( @button, SIGNAL( 'clicked()' ), 
   @bar, SLOT( 'clear()' ) )

