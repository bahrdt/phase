//  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/configwindow.cpp
//  Date      : <16 Aug 11 12:20:33 flechsig> 
//  Time-stamp: <14 Nov 11 13:54:05 flechsig> 
//  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

//  $Source$ 
//  $Date$
//  $Revision$ 
//  $Author$ 

// the configure window

#include <string.h>
#include <QtGui>
#include "configwindow.h"

// the constructor
ConfigWindow::ConfigWindow(PhaseQt *parent)
{
#ifdef DEBUG
  printf("debug: ConfigWindow constructor called, file: %s, line: %d\n", __FILE__,  __LINE__);
#endif
  configWindowBox = new QWidget();
  configWindowBox->setWindowTitle(tr("PHASE configuration"));
  QLabel *configLabel = new QLabel(tr("configure auxiliary files"));
  fileList = new QListWidget();
  QGroupBox   *lowerButtonGroup  = new QGroupBox(tr(""));
  QHBoxLayout *lowerButtonLayout = new QHBoxLayout;
  configApplyB   = new QPushButton(tr("&Apply"));
  configQuitB    = new QPushButton(tr("&Quit"));
  lowerButtonLayout->addWidget(configApplyB);
  lowerButtonLayout->addWidget(configQuitB);
  lowerButtonGroup->setLayout(lowerButtonLayout);

  QVBoxLayout *vbox = new QVBoxLayout;
  vbox->addWidget(configLabel);
  vbox->addWidget(fileList);
  vbox->addWidget(lowerButtonGroup);
  configWindowBox->setLayout(vbox);

  connect(configApplyB, SIGNAL(clicked()), this,  SLOT(applySlot()));
  connect(configQuitB,  SIGNAL(clicked()), this,  SLOT(quitSlot()));
  connect(fileList,     SIGNAL(itemSelectionChanged()), this, SLOT(selectSlot()));
  myparent= parent;
  fillList();

  configWindowBox->show();
  //  configWindowBox->setAttribute(Qt::WA_DeleteOnClose);
} // end constructor

void ConfigWindow::applySlot()
{
  printf("applySlot called\nno function so far\n");
} // applySlot

void ConfigWindow::quitSlot()
{
  this->configWindowBox->close();
} // quitSlot

// does almost everything here
void ConfigWindow::selectSlot()
{
  QListWidgetItem *item;
  int elementnumber= fileList->currentRow();
  char *text, *cp, *cp1, *fname, buffer[310], oldname[MaxPathLength], 
    extension[10], filter[50];

  if (elementnumber < 0) 
    return;
  
  item= fileList->currentItem();
  text= item->text().toAscii().data();
  strncpy(buffer, text, 310);                 // save old entry buffer
  cp= strchr(buffer, ':');
  ++cp; 
  ++cp;                                      // cp points now to the start of the filename
  cp1= cp;                                   // remember position in buffer;   
  if (cp != NULL) 
    {
      strncpy(oldname, cp, MaxPathLength);
      printf("selected file: >>%s<<\n", cp);
      cp= basename(cp);
      cp= strchr(cp, '.'); 
      strncpy(extension, cp, 10);
      extension[9]= '\0';
      sprintf(filter, "Files (*%s);;(*)", extension);
      *cp1= '\0';  // terminate buffer
    }
  else 
    return;
  
#ifdef DEBUG
  printf("DEBUG selectSlot:\n  description: >>%s<<, oldname: >>%s<<, extension: >>%s<<\n", 
	 buffer, oldname, extension);
#endif
  
  QFileDialog *dialog = new QFileDialog(this);
  dialog->selectFile(oldname);
  
  QString fileName = dialog->getSaveFileName(this, tr("Define File Name"), 
					     QDir::currentPath(),
					     tr(filter)
					     );
  
  
  if (!fileName.isEmpty()) 
    {
      //printf("description: >>%s<<\nevaluate  \n", buffer);
      fname= fileName.toAscii().data();
      
      // update data
      
      if ( !strncmp(buffer, "optimization input", 16) ) 
	strncpy(myparent->optipckname, fname, MaxPathLength); else
	if ( !strncmp(buffer, "optimization results", 16) ) 
	  strncpy(myparent->opresname, fname, MaxPathLength); else
	  if ( !strncmp(buffer, "minuit input", 10) ) 
	    strncpy(myparent->minname, fname, MaxPathLength); else
	    if ( !strncmp(buffer, "ray input (source)", 6) ) 
	      strncpy(myparent->sourceraysname, fname, MaxPathLength); else
	      if ( !strncmp(buffer, "ray output (image)", 6) )
		strncpy(myparent->imageraysname, fname, MaxPathLength); else
		if ( !strncmp(buffer, "matrix", 4) ) 
		  strncpy(myparent->matrixname, fname, MaxPathLength); else
		  if ( !strncmp(buffer, "mapname", 4) ) 
		    strncpy(myparent->mapname, fname, MaxPathLength); else
		    if ( !strncmp(buffer, "so4_fsource4a", 13) )
		      { 
			strncpy(myparent->so4_fsource4a, fname, MaxPathLength);
			strncpy(myparent->myBeamline()->src.so4.fsource4a, fname, 80);
		      } else
		      if ( !strncmp(buffer, "so4_fsource4b", 13) ) 
			{
			  strncpy(myparent->so4_fsource4b, fname, MaxPathLength);
			  strncpy(myparent->myBeamline()->src.so4.fsource4b, fname, 80);
			} else
			if ( !strncmp(buffer, "so4_fsource4c", 13) )
			  { 
			    strncpy(myparent->so4_fsource4c, fname, MaxPathLength);
			    strncpy(myparent->myBeamline()->src.so4.fsource4c, fname, 80);
			  } else
			  if ( !strncmp(buffer, "so4_fsource4d", 13) ) 
			    {
			      strncpy(myparent->so4_fsource4d, fname, MaxPathLength);
			      strncpy(myparent->myBeamline()->src.so4.fsource4d, fname, 80);
			    } else
			    if ( !strncmp(buffer, "so6_fsource6", 3) ) 
			      {
				strncpy(myparent->so6_fsource6, fname, MaxPathLength); 
				strncpy(myparent->myBeamline()->src.so6.fsource6, fname, 80);
			      }
			    else

		    printf("selectSlot: error: no matching buffer: >>%s<<\n", buffer);
      
      // update widget
      mkRow(buffer, buffer, fname);
      item->setText(buffer);
    }
} // selectSlot

// add all files to be configured with description
void ConfigWindow::fillList()
{

  char slist[13][310];
  // we allow 50 characters description and 20 for the filename

  mkRow(slist[0], "beamline name \t: ",        myparent->myPHASEset()->beamlinename);
  mkRow(slist[3], "optimization input \t: ",   myparent->myPHASEset()->optipckname);
  mkRow(slist[4], "optimization results \t: ", myparent->myPHASEset()->opresname);
  mkRow(slist[5], "minuit input \t: ",         myparent->myPHASEset()->minname);
  mkRow(slist[1], "ray input (source) \t: ",   myparent->myPHASEset()->sourceraysname);
  mkRow(slist[2], "ray output (image) \t: ",   myparent->myPHASEset()->imageraysname);
  mkRow(slist[6], "matrix \t: ",               myparent->myPHASEset()->matrixname);
  mkRow(slist[7], "mapname \t: ",              myparent->myPHASEset()->mapname);
  mkRow(slist[8], "so4_fsource4a \t: ",        myparent->myPHASEset()->so4_fsource4a);
  mkRow(slist[9], "so4_fsource4b \t: ",        myparent->myPHASEset()->so4_fsource4b);
  mkRow(slist[10], "so4_fsource4c \t: ",       myparent->myPHASEset()->so4_fsource4c);
  mkRow(slist[11], "so4_fsource4d \t: ",       myparent->myPHASEset()->so4_fsource4d);
  mkRow(slist[12], "so4_fsource6 \t: ",        myparent->myPHASEset()->so6_fsource6);
  
  fileList->setAlternatingRowColors(true);
  fileList->addItems(QStringList()
		     //	     << slist[0]  // beamline name should not be changed here
		     << slist[1]
		     << slist[2]
		     << slist[3]
		     << slist[4]
		     << slist[5]
		     << slist[6]
		     << slist[7]
		     << slist[8]
		     << slist[9]
		     << slist[10]
		     << slist[11]
		     << slist[12]
		     );
} // fillList

// helper function
void ConfigWindow::mkRow(char *out, const char *desc, const char *fname)
{
  strncpy(out, desc,  50);
  strncat(out, fname, 260);
} // mkRow

// add all files to be configured with description
void ConfigWindow::updateList()
{
  int i;
  char slist[13][310];
  // we allow 50 characters description and 20 for the filename

  mkRow(slist[0], "beamline name \t: ",        myparent->myPHASEset()->beamlinename);
  mkRow(slist[3], "optimization input \t: ",   myparent->myPHASEset()->optipckname);
  mkRow(slist[4], "optimization results \t: ", myparent->myPHASEset()->opresname);
  mkRow(slist[5], "minuit input \t: ",         myparent->myPHASEset()->minname);
  mkRow(slist[1], "ray input (source) \t: ",   myparent->myPHASEset()->sourceraysname);
  mkRow(slist[2], "ray output (image) \t: ",   myparent->myPHASEset()->imageraysname);
  mkRow(slist[6], "matrix \t: ",               myparent->myPHASEset()->matrixname);
  mkRow(slist[7], "mapname \t: ",              myparent->myPHASEset()->mapname);
  mkRow(slist[8], "so4_fsource4a \t: ",        myparent->myPHASEset()->so4_fsource4a);
  mkRow(slist[9], "so4_fsource4b \t: ",        myparent->myPHASEset()->so4_fsource4b);
  mkRow(slist[10], "so4_fsource4c \t: ",       myparent->myPHASEset()->so4_fsource4c);
  mkRow(slist[11], "so4_fsource4d \t: ",       myparent->myPHASEset()->so4_fsource4d);
  mkRow(slist[12], "so4_fsource6 \t: ",        myparent->myPHASEset()->so6_fsource6);
  
  for (i=1; i< 13; i++)
    {
      QListWidgetItem *item= fileList->item(i-1);
      item->setText(slist[i]);
    }
} // updateList

// end
