//  File      : /afs/psi.ch/user/f/flechsig/phase/src/qtgui/mainwindow.cpp
//  Date      : <31 May 11 17:02:14 flechsig> 
//  Time-stamp: <01 Jun 11 17:16:14 flechsig> 
//  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

//  $Source$ 
//  $Date$
//  $Revision$ 
//  $Author$ 


#include <QtGui>
//#include <qsignalmapper.h> 

#include "mainwindow.h"

MainWindow::MainWindow()
{
    textEdit = new QTextEdit;
    setCentralWidget(textEdit);

    createActions();
    createMenus();
    createToolBars();
    createStatusBar();
    createDockWindows();

    setWindowTitle(tr("PHASE Qt"));

    newLetter();
    setUnifiedTitleAndToolBarOnMac(true);
}

// slot
void MainWindow::newLetter()
{
    textEdit->clear();

    QTextCursor cursor(textEdit->textCursor());
    cursor.movePosition(QTextCursor::Start);
    QTextFrame *topFrame = cursor.currentFrame();
    QTextFrameFormat topFrameFormat = topFrame->frameFormat();
    topFrameFormat.setPadding(16);
    topFrame->setFrameFormat(topFrameFormat);

    QTextCharFormat textFormat;
    QTextCharFormat boldFormat;
    boldFormat.setFontWeight(QFont::Bold);
    QTextCharFormat italicFormat;
    italicFormat.setFontItalic(true);

    QTextTableFormat tableFormat;
    tableFormat.setBorder(1);
    tableFormat.setCellPadding(16);
    tableFormat.setAlignment(Qt::AlignRight);
    cursor.insertTable(1, 1, tableFormat);
    cursor.insertText("The Firm", boldFormat);
    cursor.insertBlock();
    cursor.insertText("321 City Street", textFormat);
    cursor.insertBlock();
    cursor.insertText("Industry Park");
    cursor.insertBlock();
    cursor.insertText("Some Country");
    cursor.setPosition(topFrame->lastPosition());
    cursor.insertText(QDate::currentDate().toString("d MMMM yyyy"), textFormat);
    cursor.insertBlock();
    cursor.insertBlock();
    cursor.insertText("Dear ", textFormat);
    cursor.insertText("NAME", italicFormat);
    cursor.insertText(",", textFormat);
    for (int i = 0; i < 3; ++i)
        cursor.insertBlock();
    cursor.insertText(tr("Yours sincerely,"), textFormat);
    for (int i = 0; i < 3; ++i)
        cursor.insertBlock();
    cursor.insertText("The Boss", textFormat);
    cursor.insertBlock();
    cursor.insertText("ADDRESS", italicFormat);
}

// slot
void MainWindow::print()
{
#ifndef QT_NO_PRINTDIALOG
    QTextDocument *document = textEdit->document();
    QPrinter printer;

    QPrintDialog *dlg = new QPrintDialog(&printer, this);
    if (dlg->exec() != QDialog::Accepted)
        return;

    document->print(&printer);

    statusBar()->showMessage(tr("Ready"), 2000);
#endif
}

// slot
void MainWindow::save()
{
    QString fileName = QFileDialog::getSaveFileName(this,
                        tr("Choose a file name"), ".",
                        tr("HTML (*.html *.htm)"));
    if (fileName.isEmpty())
        return;
    QFile file(fileName);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
        QMessageBox::warning(this, tr("PHASE Qt"),
                             tr("Cannot write file %1:\n%2.")
                             .arg(fileName)
                             .arg(file.errorString()));
        return;
    }

    QTextStream out(&file);
    QApplication::setOverrideCursor(Qt::WaitCursor);
    out << textEdit->toHtml();
    QApplication::restoreOverrideCursor();

    statusBar()->showMessage(tr("Saved '%1'").arg(fileName), 2000);
}

// slot
void MainWindow::undo()
{
    QTextDocument *document = textEdit->document();
    document->undo();
}

// slot
// insert customer from list into letter
void MainWindow::insertCustomer(const QString &customer)
{
    if (customer.isEmpty())
        return;
    QStringList customerList = customer.split(", ");
    QTextDocument *document = textEdit->document();
    QTextCursor cursor = document->find("NAME");
    if (!cursor.isNull()) {
        cursor.beginEditBlock();
        cursor.insertText(customerList.at(0));
        QTextCursor oldcursor = cursor;
        cursor = document->find("ADDRESS");
        if (!cursor.isNull()) {
            for (int i = 1; i < customerList.size(); ++i) {
                cursor.insertBlock();
                cursor.insertText(customerList.at(i));
            }
            cursor.endEditBlock();
        }
        else
            oldcursor.endEditBlock();
    }
}

// slot
// insert standard text from list into letter
void MainWindow::addParagraph(const QString &paragraph)
{
    if (paragraph.isEmpty())
        return;
    QTextDocument *document = textEdit->document();
    QTextCursor cursor = document->find(tr("Yours sincerely,"));
    if (cursor.isNull())
        return;
    cursor.beginEditBlock();
    cursor.movePosition(QTextCursor::PreviousBlock, QTextCursor::MoveAnchor, 2);
    cursor.insertBlock();
    cursor.insertText(paragraph);
    cursor.insertBlock();
    cursor.endEditBlock();

}

// slot
void MainWindow::about()
{
   QMessageBox::about(this, tr("About PHASE Qt"),
            tr("The <b>PHASE Qt</b> example demonstrates how to "
               "use Qt's dock widgets. You can enter your own text, "
               "click a customer to add a customer name and "
               "address, and click standard paragraphs to add them."));
}


// UF slot
// here we call our own code dependign on which button has been pressed
void MainWindow::activateProc(const QString &action)

{
  if (action.isEmpty())
          return;
  
  if (!action.compare("raytracesimpleAct")) printf("raytracesimpleAct button  pressed\n"); 
  if (!action.compare("raytracefullAct"))   printf("raytracefullAct button pressed\n"); 
  if (!action.compare("footprintAct"))      printf("footprintAct button pressed\n"); 
  if (!action.compare("phasespaceAct"))     printf("phasespaceAct button pressed\n"); 
  if (!action.compare("mphasespaceAct"))    printf("mphasespaceAct button pressed\n"); 
  
} // end activateProc

///////////////////////////////////////////////////////////////////////////////////
// define action buttons
void MainWindow::createActions()
{
    newLetterAct = new QAction(QIcon(":/images/new.png"), tr("&New Letter"),
                               this);
    newLetterAct->setShortcuts(QKeySequence::New);
    newLetterAct->setStatusTip(tr("Create a new form letter"));
    connect(newLetterAct, SIGNAL(triggered()), this, SLOT(newLetter()));

    saveAct = new QAction(QIcon(":/images/save.png"), tr("&Save..."), this);
    saveAct->setShortcuts(QKeySequence::Save);
    saveAct->setStatusTip(tr("Save the current form letter"));
    connect(saveAct, SIGNAL(triggered()), this, SLOT(save()));

    printAct = new QAction(QIcon(":/images/print.png"), tr("&Print..."), this);
    printAct->setShortcuts(QKeySequence::Print);
    printAct->setStatusTip(tr("Print the current form letter"));
    connect(printAct, SIGNAL(triggered()), this, SLOT(print()));

    undoAct = new QAction(QIcon(":/images/undo.png"), tr("&Undo"), this);
    undoAct->setShortcuts(QKeySequence::Undo);
    undoAct->setStatusTip(tr("Undo the last editing action"));
    connect(undoAct, SIGNAL(triggered()), this, SLOT(undo()));

    quitAct = new QAction(tr("&Quit"), this);
    quitAct->setShortcuts(QKeySequence::Quit);
    quitAct->setStatusTip(tr("Quit the application"));
    connect(quitAct, SIGNAL(triggered()), this, SLOT(close()));

    aboutAct = new QAction(tr("&About"), this);
    aboutAct->setStatusTip(tr("Show the application's About box"));
    connect(aboutAct, SIGNAL(triggered()), this, SLOT(about()));

    aboutQtAct = new QAction(tr("About &Qt"), this);
    aboutQtAct->setStatusTip(tr("Show the Qt library's About box"));
    connect(aboutQtAct, SIGNAL(triggered()), qApp, SLOT(aboutQt()));

// UF 
// we use the signal mapper to determin which button has been clicked
// and pass the name of the button as string which is then evaluated by activateProc
    signalMapper = new QSignalMapper(this);

    raytracesimpleAct = new QAction(tr("GO &Simple ray tracing"), this);
    raytracesimpleAct->setStatusTip(tr("geometrical optics, simple ray tracing"));
    signalMapper->setMapping(raytracesimpleAct, QString("raytracesimpleAct"));
    connect(raytracesimpleAct, SIGNAL(triggered()), signalMapper, SLOT(map()));

    raytracefullAct = new QAction(tr("GO &Full ray tracing"), this);
    raytracefullAct->setStatusTip(tr("geometrical optics, full ray tracing"));
    signalMapper->setMapping(raytracefullAct, QString("raytracefullAct"));
    connect(raytracefullAct, SIGNAL(triggered()), signalMapper, SLOT(map()));
   
    footprintAct = new QAction(tr("GO &footprint at selected element"), this);
    footprintAct->setStatusTip(tr("geometrical optics, footprint at selected element"));
    signalMapper->setMapping(footprintAct, QString("footprintAct"));
    connect(footprintAct, SIGNAL(triggered()), signalMapper, SLOT(map()));

    phasespaceAct = new QAction(tr("PO &phase space imaging"), this);
    phasespaceAct->setStatusTip(tr("physical optics, phase space imaging"));
    signalMapper->setMapping(phasespaceAct, QString("phasespaceAct"));
    connect(phasespaceAct, SIGNAL(triggered()), signalMapper, SLOT(map()));

    mphasespaceAct = new QAction(tr("PO &multiple phase space imaging"), this);
    mphasespaceAct->setStatusTip(tr("physical optics, multiple phase space imaging"));
    signalMapper->setMapping(mphasespaceAct, QString("mphasespaceAct"));
    connect(mphasespaceAct, SIGNAL(triggered()), signalMapper, SLOT(map()));

    // finaly connect mapper to acticateProc
    connect(signalMapper, SIGNAL(mapped(QString)), this, SLOT(activateProc(QString)));
}

// create menus with buttons
void MainWindow::createMenus()
{
    fileMenu = menuBar()->addMenu(tr("&File"));
    fileMenu->addAction(newLetterAct);
    fileMenu->addAction(saveAct);
    fileMenu->addAction(printAct);
    fileMenu->addSeparator();
    fileMenu->addAction(quitAct);

    editMenu = menuBar()->addMenu(tr("&Edit"));
    editMenu->addAction(undoAct);

    calcMenu = menuBar()->addMenu(tr("&Calc"));
    calcMenu->addAction(raytracesimpleAct);
    calcMenu->addAction(raytracefullAct);
    calcMenu->addAction(footprintAct);
    calcMenu->addSeparator();
    calcMenu->addAction(phasespaceAct);
    calcMenu->addAction(mphasespaceAct);

    viewMenu = menuBar()->addMenu(tr("&View"));

    menuBar()->addSeparator();

    helpMenu = menuBar()->addMenu(tr("&Help"));
    helpMenu->addAction(aboutAct);
    helpMenu->addAction(aboutQtAct);
}


// toolbar with icons
void MainWindow::createToolBars()
{
    fileToolBar = addToolBar(tr("File"));
    fileToolBar->addAction(newLetterAct);
    fileToolBar->addAction(saveAct);
    fileToolBar->addAction(printAct);

    editToolBar = addToolBar(tr("Edit"));
    editToolBar->addAction(undoAct);
}

// statusbar at the bottom
void MainWindow::createStatusBar()
{
    statusBar()->showMessage(tr("Ready"));
}

// dock widgets
void MainWindow::createDockWindows()
{
    QDockWidget *dock = new QDockWidget(tr("Customers"), this);
    dock->setAllowedAreas(Qt::LeftDockWidgetArea | Qt::RightDockWidgetArea);
    customerList = new QListWidget(dock);
    customerList->addItems(QStringList()
            << "John Doe, Harmony Enterprises, 12 Lakeside, Ambleton"
            << "Jane Doe, Memorabilia, 23 Watersedge, Beaton"
            << "Tammy Shea, Tiblanka, 38 Sea Views, Carlton"
            << "Tim Sheen, Caraba Gifts, 48 Ocean Way, Deal"
            << "Sol Harvey, Chicos Coffee, 53 New Springs, Eccleston"
            << "Sally Hobart, Tiroli Tea, 67 Long River, Fedula");
    dock->setWidget(customerList);
    addDockWidget(Qt::RightDockWidgetArea, dock);
    viewMenu->addAction(dock->toggleViewAction());

 

    dock = new QDockWidget(tr("Paragraphs"), this);
    paragraphsList = new QListWidget(dock);
    paragraphsList->addItems(QStringList()
            << "Thank you for your payment which we have received today."
            << "Your order has been dispatched and should be with you "
               "within 28 days."
            << "We have dispatched those items that were in stock. The "
               "rest of your order will be dispatched once all the "
               "remaining items have arrived at our warehouse. No "
               "additional shipping charges will be made."
            << "You made a small overpayment (less than $5) which we "
               "will keep on account for you, or return at your request."
            << "You made a small underpayment (less than $1), but we have "
               "sent your order anyway. We'll add this underpayment to "
               "your next bill."
            << "Unfortunately you did not send enough money. Please remit "
               "an additional $. Your order will be dispatched as soon as "
               "the complete amount has been received."
            << "You made an overpayment (more than $5). Do you wish to "
               "buy more items, or should we return the excess to you?");
    dock->setWidget(paragraphsList);
    addDockWidget(Qt::RightDockWidgetArea, dock);
    viewMenu->addAction(dock->toggleViewAction());


    dock = new QDockWidget(tr("Paragraphs1"), this);
    paragraphsList1 = new QListWidget(dock);
    paragraphsList1->addItems(QStringList()
            << "Thank you for your payment which we have received today."
            << "Your order has been dispatched and should be with you "
               "within 28 days."
			     << "You made an overpayment (more than $5). Do you wish to "
               "buy more items, or should we return the excess to you?");
    dock->setWidget(paragraphsList1);
    addDockWidget(Qt::RightDockWidgetArea, dock);
    viewMenu->addAction(dock->toggleViewAction());

    // the optical element box

    dock = new QDockWidget(tr("Optical Element Box"), this);
    dock->setWidget(createOpticalElementBox());

    addDockWidget(Qt::RightDockWidgetArea, dock);
    viewMenu->addAction(dock->toggleViewAction());


    connect(customerList, SIGNAL(currentTextChanged(QString)),
            this, SLOT(insertCustomer(QString)));
    connect(paragraphsList, SIGNAL(currentTextChanged(QString)),
            this, SLOT(addParagraph(QString)));
}

QWidget *MainWindow::createOpticalElementBox()
{
  elementBox = new QWidget();

  //radio buttons
  QGroupBox *groupBox = new QGroupBox(tr("orientation (reflection to)"));
  QRadioButton *radio1 = new QRadioButton(tr("&up"));
  QRadioButton *radio2 = new QRadioButton(tr("&left"));
  QRadioButton *radio3 = new QRadioButton(tr("&down"));
  QRadioButton *radio4 = new QRadioButton(tr("&right"));
  radio1->setChecked(true);
  
  // popup button
  QPushButton *popupButton = new QPushButton(tr("&Shape"));
  QMenu *menu = new QMenu(this);
  menu->addAction(tr("&flat mirror"));
  menu->addAction(tr("&toroidal mirror"));
  menu->addAction(tr("&plane- elliptical mirror"));
  menu->addAction(tr("&elliptical mirror"));
  menu->addAction(tr("&conical mirror"));
  menu->addSeparator();
  menu->addAction(tr("&plane grating"));
  popupButton->setMenu(menu);

  QHBoxLayout *hbox = new QHBoxLayout;
  hbox->addWidget(radio1);
  hbox->addWidget(radio2);
  hbox->addWidget(radio3);
  hbox->addWidget(radio4);
  hbox->addStretch(1);
  groupBox->setLayout(hbox);

  QGroupBox *groupBox1 = new QGroupBox(tr("&Element"));
  QHBoxLayout *hbox1 = new QHBoxLayout;
  hbox1->addWidget(popupButton);
  hbox1->addWidget(groupBox);
  groupBox1->setLayout(hbox1);

  //radius
  QGroupBox *geometryGroup = new QGroupBox(tr("&geometry and shape parameters (support fields in red)"));
  QGridLayout *geometryLayout = new QGridLayout;
  QLabel *cffLabel = new QLabel(tr("cff (PGM)"));
  QLabel *preLabel = new QLabel(tr("Prec (mm)"));
  QLabel *sucLabel = new QLabel(tr("Succ (mm)"));
  QLabel *thetaLabel = new QLabel(tr("theta (deg)"));
  QLabel *sourceLabel = new QLabel(tr("Source (mm)"));
  QLabel *imageLabel = new QLabel(tr("Image (mm)"));
  QLabel *rLabel = new QLabel(tr("r (mm)"));
  QLabel *rhoLabel = new QLabel(tr("rho (mm)"));

  QLineEdit *cffE = new QLineEdit;
  QLineEdit *preE = new QLineEdit;
  QLineEdit *sucE = new QLineEdit;
  QLineEdit *thetaE = new QLineEdit;
  QLineEdit *sourceE = new QLineEdit;
  QLineEdit *imageE = new QLineEdit;
  QLineEdit *rE = new QLineEdit;
  QLineEdit *rhoE = new QLineEdit;

  QPushButton *thetaB = new QPushButton(tr("next"));
  QPushButton *sourceB = new QPushButton(tr("next"));
  QPushButton *imageB = new QPushButton(tr("next"));
  QPushButton *rB = new QPushButton(tr("next"));
  QPushButton *rhoB = new QPushButton(tr("next"));

  geometryLayout->addWidget(cffLabel,0,0);
  geometryLayout->addWidget(preLabel,1,0);
  geometryLayout->addWidget(sucLabel,2,0);

  geometryLayout->addWidget(cffE,0,1);
  geometryLayout->addWidget(preE,1,1);
  geometryLayout->addWidget(sucE,2,1);

  geometryLayout->addWidget(thetaB, 0,2);
  geometryLayout->addWidget(sourceB,1,2);
  geometryLayout->addWidget(imageB, 2,2);

  geometryLayout->addWidget(thetaLabel, 0,3);
  geometryLayout->addWidget(sourceLabel,1,3);
  geometryLayout->addWidget(imageLabel, 2,3);

  geometryLayout->addWidget(thetaE, 0,4);
  geometryLayout->addWidget(sourceE,1,4);
  geometryLayout->addWidget(imageE, 2,4);

  geometryLayout->addWidget(rB,  0,5);
  geometryLayout->addWidget(rhoB,1,5);

  geometryLayout->addWidget(rLabel,  0,6);
  geometryLayout->addWidget(rhoLabel,1,6);
  geometryLayout->addWidget(rE,  0,7);
  geometryLayout->addWidget(rhoE,1,7);

  geometryGroup->setLayout(geometryLayout);
  //radius

  // grating
  QGroupBox *gratingGroup = new QGroupBox(tr("&Grating"));
  gratingGroup->setCheckable(true);
  gratingGroup->setChecked(true);

  QLabel *orderLabel   = new QLabel(tr("Diffraction order"));
  QLabel *densityLabel = new QLabel(tr("line density (1/mm)"));
  QSpinBox *integerSpinBox = new QSpinBox;
  integerSpinBox->setRange(-20, 20);
  integerSpinBox->setSingleStep(1);
  integerSpinBox->setValue(1);
  QLineEdit *lineDensity = new QLineEdit;
  QCheckBox *nimBox = new QCheckBox(tr("&NIM Translation"));

  // vls
  QGroupBox *vlsGroup = new QGroupBox(tr("&VLS Grating"));
  vlsGroup->setCheckable(true);
  vlsGroup->setChecked(false);
  QHBoxLayout *vlslayout = new QHBoxLayout;
  QLabel *vlsLabel = new QLabel(tr("coeff(1)...coeff(4)"));
  QLineEdit *vls1 = new QLineEdit;
  QLineEdit *vls2 = new QLineEdit;
  QLineEdit *vls3 = new QLineEdit;
  QLineEdit *vls4 = new QLineEdit;
  vlslayout->addWidget(vlsLabel);
  vlslayout->addWidget(vls1);
  vlslayout->addWidget(vls2);
  vlslayout->addWidget(vls3);
  vlslayout->addWidget(vls4);
  vlsGroup->setLayout(vlslayout);
  // end VLS

  QGroupBox *gratingGroup1 = new QGroupBox(tr("g&rating parameter"));
  QHBoxLayout *gratingLayout1 = new QHBoxLayout;
  gratingLayout1->addWidget(densityLabel);
  gratingLayout1->addWidget(lineDensity);
  gratingLayout1->addWidget(orderLabel);
  gratingLayout1->addWidget(integerSpinBox);
  gratingLayout1->addStretch(1);
  gratingLayout1->addWidget(nimBox);
  gratingGroup1->setLayout(gratingLayout1);

  QVBoxLayout *gratingLayout2 = new QVBoxLayout;
  gratingLayout2->addWidget(gratingGroup1);
  gratingLayout2->addWidget(vlsGroup);
  gratingGroup->setLayout(gratingLayout2);
  // end grating

  // misalignment
 QGroupBox *alignmentGroup = new QGroupBox(tr("&misalignment, opt. surface size, slope errors (arcsec)"));
 QGridLayout *alignmentLayout = new QGridLayout;
 QLabel *duLabel = new QLabel(tr("du (mm)"));
 QLabel *dwLabel = new QLabel(tr("dw (mm)"));
 QLabel *dlLabel = new QLabel(tr("dl (mm)"));
 QLabel *dRuLabel = new QLabel(tr("du (mrad)"));
 QLabel *dRwLabel = new QLabel(tr("dw (mrad)"));
 QLabel *dRlLabel = new QLabel(tr("dl (mrad)"));
 QLabel *w1Label = new QLabel(tr("w1 (mm)"));
 QLabel *w2Label = new QLabel(tr("w2 (mm)"));
 QLabel *wsLabel = new QLabel(tr("w slope"));
 QLabel *l1Label = new QLabel(tr("l1 (mm)"));
 QLabel *l2Label = new QLabel(tr("l2 (mm)"));
 QLabel *lsLabel = new QLabel(tr("l slope"));

 QLineEdit *duE = new QLineEdit;
 QLineEdit *dwE = new QLineEdit;
 QLineEdit *dlE = new QLineEdit;
 QLineEdit *dRuE = new QLineEdit;
 QLineEdit *dRwE = new QLineEdit;
 QLineEdit *dRlE = new QLineEdit;
 QLineEdit *w1E = new QLineEdit;
 QLineEdit *w2E = new QLineEdit;
 QLineEdit *wsE = new QLineEdit;
 QLineEdit *l1E = new QLineEdit;
 QLineEdit *l2E = new QLineEdit;
 QLineEdit *lsE = new QLineEdit;


 alignmentLayout->addWidget(duLabel,0,0);
 alignmentLayout->addWidget(dwLabel,1,0);
 alignmentLayout->addWidget(dlLabel,2,0);
 alignmentLayout->addWidget(duE,0,1);
 alignmentLayout->addWidget(dwE,1,1);
 alignmentLayout->addWidget(dlE,2,1);

 alignmentLayout->addWidget(dRuLabel,0,2);
 alignmentLayout->addWidget(dRwLabel,1,2);
 alignmentLayout->addWidget(dRlLabel,2,2);
 alignmentLayout->addWidget(dRuE,0,3);
 alignmentLayout->addWidget(dRwE,1,3);
 alignmentLayout->addWidget(dRlE,2,3);

 alignmentLayout->addWidget(w1Label,0,4);
 alignmentLayout->addWidget(w2Label,1,4);
 alignmentLayout->addWidget(wsLabel,2,4);
 alignmentLayout->addWidget(w1E,0,5);
 alignmentLayout->addWidget(w2E,1,5);
 alignmentLayout->addWidget(wsE,2,5);

 alignmentLayout->addWidget(l1Label,0,6);
 alignmentLayout->addWidget(l2Label,1,6);
 alignmentLayout->addWidget(lsLabel,2,6);
 alignmentLayout->addWidget(l1E,0,7);
 alignmentLayout->addWidget(l2E,1,7);
 alignmentLayout->addWidget(lsE,2,7);

 alignmentGroup->setLayout(alignmentLayout);
 // end misalignment
 
  QVBoxLayout *vbox = new QVBoxLayout;
  vbox->addWidget(groupBox1);
  vbox->addWidget(geometryGroup);
  vbox->addWidget(gratingGroup);
  vbox->addWidget(alignmentGroup);
  elementBox->setLayout(vbox);

  return elementBox;
}
// /afs/psi.ch/user/f/flechsig/phase/src/qtgui/mainwindow.cpp
