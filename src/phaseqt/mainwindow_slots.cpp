//  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/mainwindow_slots.cpp
//  Date      : <09 Sep 11 15:22:29 flechsig> 
//  Time-stamp: <15 Sep 11 12:52:20 flechsig> 
//  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

//  $Source$ 
//  $Date$
//  $Revision$ 
//  $Author$ 

//
// only the slots
//



#include <QtGui>

#include "mainwindow.h"
#include "phaseqt.h"

//////////////////////////////////////////////
// begin slots section (callback functions) //
//////////////////////////////////////////////

// slot
void MainWindow::about()
{
#ifdef SEVEN_ORDER
  const char *onoff="on";
#else
  const char *onoff="off";
#endif

   QMessageBox::about(this, tr("About PhaseQt"),
            tr("<b>phaseqt</b> is the new graphical user interface for the software package <b>phase</b>-"
               "the wave front propagation and ray tracing code developed by "
               "<center><a href=mailto:Johannes.Bahrdt@helmholtz-berlin.de>Johannes Bahrdt</a>, <a href=mailto:uwe.flechsig&#64;psi.&#99;&#104;>Uwe Flechsig</a> and others. </center><hr>"
               "<center>phaseqt version: '%1',<br>"
               "configured: '%2',<br>"
               "SEVEN_ORDER: '%3'</center>").arg(VERSION).arg(CONFIGURED).arg(onoff));
} // about

// UF slot
// here we call our own code dependign on which button has been pressed
void MainWindow::activateProc(const QString &action)
{
  char buffer[MaxPathLength], header[MaxPathLength];

  if (action.isEmpty())
          return;
  
  if (!action.compare("raytracesimpleAct")) 
    { 
      printf("\nraytracesimpleAct button  pressed, localalloc: %d hormaps_loaded: %d\n", this->localalloc, this->hormapsloaded);
      this->beamlineOK &= ~resultOK;
      UpdateStatus();
      if (!(this->beamlineOK & sourceOK))
	MakeRTSource(this, this);
		
      ReAllocResult(this, PLrttype, this->RTSource.raynumber, 0);  
      BuildBeamline(this);
      RayTracec(this); 
      printf("ray trace-> done\n");
      statusBar()->showMessage(tr("Quick ray trace-> done!"), 4000);
    }
  if (!action.compare("raytracefullAct")) 
    { 
      printf("\nraytracefullAct button  pressed\n");
      this->beamlineOK &= ~resultOK;
      UpdateStatus();
      if (!(this->beamlineOK & sourceOK))
	MakeRTSource(this, this);
      ReAllocResult(this, PLrttype, this->RTSource.raynumber, 0);  
	
      BuildBeamline(this);
      RayTraceFull(this); 
      printf("full ray trace-> done\n");
      statusBar()->showMessage(tr("full ray trace-> done!"), 4000);

    }
  if (!action.compare("footprintAct")) 
    { 
      printf("\nfootprintAct button  pressed\n");
      
      
      
      if (!(this->beamlineOK & sourceOK))
	MakeRTSource(this, this);
      ReAllocResult(this, PLrttype, this->RTSource.raynumber, 0);  
      BuildBeamline(this);
      Footprint(this, this->position);
      printf("footprint-> done\n");
      statusBar()->showMessage(tr("Footprint-> done!"), 4000);
    }

  if (!action.compare("singleRayAct")) 
    { 
      printf("singleRayAct button pressed\n");
      if (!s_ray) 
	s_ray= new SingleRay((struct BeamlineType *) this, this); 
      else 
	s_ray->singleRayBox->show();
    }

  if (!action.compare("optiInputAct")) 
    { 
      printf("optiInputAct button pressed %d\n", this->elementzahl);
      if (!o_input) 
	o_input= new OptiInput(this->ElementList, this->elementzahl,
			       this->beamlinename, this->optipckname, 
			       this->opresname, this->minname); 
      else 
	o_input->optiInputBox->show();
    }

  if (!action.compare("phasespaceAct"))     printf("phasespaceAct button pressed\n"); 
  if (!action.compare("mphasespaceAct"))    printf("mphasespaceAct button pressed\n"); 

  if (!action.compare("rthAct")) { this->RTSource.QuellTyp= 'H'; UpdateSourceBox(); }
  if (!action.compare("dipAct")) { this->RTSource.QuellTyp= 'D'; UpdateSourceBox(); }
  if (!action.compare("poiAct")) { this->RTSource.QuellTyp= 'o'; UpdateSourceBox(); }
  if (!action.compare("rinAct")) { this->RTSource.QuellTyp= 'R'; UpdateSourceBox(); }   
  if (!action.compare("genAct")) { this->RTSource.QuellTyp= 'G'; UpdateSourceBox(); }    
  if (!action.compare("b2hAct")) { this->RTSource.QuellTyp= 'U'; UpdateSourceBox(); }   
  if (!action.compare("b2lAct")) { this->RTSource.QuellTyp= 'U'; UpdateSourceBox(); }    
  if (!action.compare("sisAct")) { this->RTSource.QuellTyp= 'L'; UpdateSourceBox(); }   
  if (!action.compare("simAct")) { this->RTSource.QuellTyp= 'M'; UpdateSourceBox(); }   
  if (!action.compare("sffAct")) { this->RTSource.QuellTyp= 'F'; UpdateSourceBox(); }  

  if (!action.compare("writemapAct")) 
    { 
      printf("writemapAct button pressed\n");
      if ((this->position <= this->elementzahl) && (this->position != 0))
	{
	  printf("write map of element %d to file\n", this->position); 
	  sprintf(header, "beamline: %s, map of element %d, iord: %d%d", 
		  this->beamlinename, this->position, this->BLOptions.ifl.iord,0);
	  sprintf(buffer, "%s-%d", this->mapname, this->position);
	  /* casting 15.12.99 ist noch nicht OK */
	  writemapc(buffer, header, this->BLOptions.ifl.iord, 
		    (double *)(this->ElementList[this->position- 1].ypc1), 
		    (double *) this->ElementList[this->position- 1].zpc1, 
		    (double *) this->ElementList[this->position- 1].dypc, 
		    (double *) this->ElementList[this->position- 1].dzpc,
		    (double *) this->ElementList[this->position- 1].wc, 
		    (double *) this->ElementList[this->position- 1].xlc, 
		    (double *) this->ElementList[this->position- 1].xlm.xlen1c, 
		    (double *) this->ElementList[this->position- 1].xlm.xlen2c);
	} 
      
      //  else wir schreiben hier immer beides
	{ 
	  printf("write map of beamline to file\n"); 
	  sprintf(header, "beamline: %s, map of beamline, iord: %d", 
		  this->beamlinename, this->BLOptions.ifl.iord);
	  sprintf(buffer, "%s-0", this->mapname);
	  writemapc(buffer,  header,  this->BLOptions.ifl.iord, 
		    (double *) this->ypc1, (double *) this->zpc1, 
		    (double *) this->dypc, (double *) this->dzpc,
		    (double *) this->wc,   (double *) this->xlc, 
		    (double *) this->xlm.xlen1c, 
		    (double *) this->xlm.xlen2c);
	}
    } 

  if (!action.compare("writematAct")) 
    { 
      printf("writematAct button pressed\n");
      if ((this->position <= this->elementzahl) && (this->position != 0))
	{
	  printf("write matrix of element %d to file\n", this->position); 
	  sprintf(header, "beamline: %s, matrix of element %d, iord: %d, REDUCE_maps: %d\x00", 
		  this->beamlinename, this->position, this->BLOptions.ifl.iord,
		  this->BLOptions.REDUCE_maps);
	  sprintf(buffer, "%s-%d\x00", this->matrixname, this->position);
          writematrixfile((double *)this->ElementList[this->position- 1].M_StoI, buffer, header, 
			  strlen(buffer), strlen(header)); // add hidden length parameter 
	} 
      
      //  else wir schreiben hier immer beides
	{ 
	  printf("activateProc: write matrix of beamline to file\n"); 
	  sprintf(header, "beamline: %s, matrix of beamline, iord: %d, REDUCE_maps: %d\x00", 
		  this->beamlinename, this->BLOptions.ifl.iord, this->BLOptions.REDUCE_maps);
	  sprintf(buffer, "%s-0\x00", this->matrixname);
	  writematrixfile((double *)this->M_StoI, buffer, header, strlen(buffer), strlen(header));
	}
    } 

  if (!action.compare("writecoeffAct")) 
    { 
      printf("writecoeffmapAct button pressed\n"); 

      //  sprintf(buffer, "%s", "mirror-coefficients.dat");
      sprintf(buffer, "%s.coeff", this->elementList->currentItem()->text().toAscii().data());
      printf("write coefficients to file: %s\n", buffer);
      WriteMKos((struct mirrortype *)&this->ElementList[this->position- 1].mir, buffer);
      statusBar()->showMessage(tr("Wrote mirror coefficients to file '%1'.").arg(buffer), 4000);
    } 

  if (!action.compare("writeRTresultAct")) 
    { 
      printf("writereRTsultAct button pressed\n"); 
      printf("write result to file: %s\n", this->imageraysname);
      WriteRayFile(this->imageraysname, &this->RESULT.points,
		   (struct RayType *)this->RESULT.RESp);
    } 
  if (!action.compare("grfootprintAct")) 
    { 
      printf("grcontourAct button pressed\n"); 
      //d_plot->showSpectrogram(true);
    } 


  if (!action.compare("grcontourAct")) 
    { 
      d_plot->showContour(false);
      d_plot->showSpectrogram(true);
    } 

  if (!action.compare("grcontourisoAct")) 
    { 
      d_plot->showSpectrogram(true);
      d_plot->showContour(true);
    } 
  if (!action.compare("grisoAct")) 
    { 
      d_plot->showSpectrogram(false);
      d_plot->showContour(true);
    } 

  if (!action.compare("grsourceAct")) 
    { 
      d_plot->plotsubject= 0;
      //  d_plot->setTitle(tr("Source Plane"));
      //  d_plot->setphaseData("grsourceAct");
    }

  if (!action.compare("grimageAct")) 
    { 
      d_plot->plotsubject= 1;
      //  d_plot->setTitle(tr("Image Plane"));
      //  d_plot->setphaseData("grimageAct");
    }

  if (!action.compare("grexample1Act")) 
    { 
      d_plot->plotsubject= 2;
      //   d_plot->setTitle(tr("PhaseQt: example 1"));
      //   d_plot->setdefaultData();
    }

  if (!action.compare("grexample2Act")) 
    { 
      d_plot->plotsubject= 3;
      //  d_plot->setTitle(tr("PhaseQt: example 2"));
      //   d_plot->setdefaultData2();
    }

  if (!action.compare("readFg34Act")) 
    { 
      printf("readFg34Act button pressed\n"); 
      printf("Initialize parameters with fg34.par from J. Bahrdt\n"); 
      if (fexists((char *)"fg34.par") == 1)
	{
	  //	  correct but src not yet implemented readfg34_par(this->src, this->BLOptions.apr,
	  readfg34_par(&this->src, &this->BLOptions.apr,
		       &this->BLOptions.ifl, &this->BLOptions.xi,
		       &this->BLOptions.epsilon);
	  parameterUpdateAll(NPARS);
	} else
	QMessageBox::warning(this, tr("readFg34Act"),
			     tr("file fg34.par not found!"));
    } 

  if (!action.compare("configureAct")) 
    { 
      printf("configure button pressed\n");
      if (!c_window) 
	c_window= new ConfigWindow((struct  PHASEset *) this); 
      else 
	c_window->configWindowBox->show();
    }
  
  UpdateStatus();
} // end activateProc


// UF slot append a new optical element in the beamline box
void MainWindow::appendElement()
{
  struct ElementType *tmplist, *listpt, *tmplistpt;
  int i;
  int pos= elementList->count();
  if (pos < 0) pos= 0;  // empty list 
  if (abs(this->elementzahl) > 1000) this->elementzahl= 0;  // fix falls elementzahl nicht initialisiert

#ifdef DEBUG
  printf("AddBLElement: AddItem at pos %d, out of %u\n", pos, this->elementzahl);  
#endif 
 
  QListWidgetItem *item= new QListWidgetItem("New Element");
  elementList->insertItem(pos, item);
  item->setFlags (item->flags () | Qt::ItemIsEditable);               // edit item
  tmplist= XMALLOC(struct ElementType, this->elementzahl); // alloc memory
  memcpy(tmplist, this->ElementList, this->elementzahl* sizeof(struct ElementType)); // copy contents
  this->elementzahl++;
  this->ElementList= XREALLOC(struct ElementType, this->ElementList, this->elementzahl);
  listpt= this->ElementList; tmplistpt= tmplist; 
  for (i= 0; i< (int)this->elementzahl; i++, listpt++)
    {
#ifdef DEBUG
      printf("i= %d, pos= %d, nmax %u\n", i, pos, this->elementzahl);
#endif
      if (i == pos)
	{
	  listpt->ElementOK= 0;
	  sprintf(listpt->elementname, "%s", "New Element");
	  minitdatset(&listpt->MDat);
	  listpt->MDat.Art= kEOETM;   // overwrite kEOEDefaults
	  ginitdatset(&listpt->GDat);
	  
	}
      else
	memcpy(listpt, tmplistpt++, sizeof(struct ElementType)); 
    }
  this->beamlineOK &= ~(mapOK | resultOK);
  //  WriteBLFile(PHASESet.beamlinename, bl); 
  XFREE(tmplist);
  printf("inserElement: end list should have %u elements\n", this->elementzahl);
  UpdateStatus();
  writeBackupFile();
} // appendElement


// calc slots in element box
void MainWindow::thetaBslot()  // SetTheta from cff
{
  double cff, alpha, beta, theta0;
  int number= elementList->currentRow();

  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			 tr("(nothing selected)"));
      return;
    }

  char *text= cffE->text().toAscii().data();          // get string from widget
  struct gdatset *gdat= &(this->ElementList[number].GDat);
  char  buffer[9];
  printf("thetaBslot: text: %s\n", text);

  // !! we take other relevant data (gdat->lambda, gdat->xdens[0], gdat->inout) from dataset and not from widget
  sscanf(text, "%lf", &cff);
  if (cff != 1.0)
    {
      printf("fixfocus: %f, %lg\n", gdat->xdens[0], this->BLOptions.lambda);
      FixFocus(cff, this->BLOptions.lambda, gdat->xdens[0], gdat->inout, &alpha, &beta);
      theta0= (alpha- beta)* 90.0/ PI;
      if (gdat->azimut > 1) theta0= -fabs(theta0);
      sprintf(buffer, "%8.4f", theta0);  
      thetaE->setText(QString(tr(buffer)));  // update widget
      gdat->theta0= theta0;                  // update data
    } 
  else
    QMessageBox::warning(this, tr("Calculate theta from cff"),
			 tr("cff=1 is undefined\ntake no action"));
}

void MainWindow::sourceBslot() // copy source distance
{
  sourceE->setText(preE->text()); // copy text from widget, no update of datasets
}

void MainWindow::imageBslot()
{
  imageE->setText(sucE->text()); // copy text from widget, no update of datasets
}

void MainWindow::rhoBslot()  // calculate roho
{
  double theta, rho, source, image;
  char buffer[10];
  
  sscanf(thetaE ->text().toAscii().data(), "%lf", &theta);  // get theta  from widget text buffer
  sscanf(sourceE->text().toAscii().data(), "%lf", &source); // get source from widget text buffer
  sscanf(imageE ->text().toAscii().data(), "%lf", &image);  // get image  from widget text buffer

  sprintf(buffer, "%9.3f", theta); // for message box
 
  if (theta >= 90.0)
    QMessageBox::warning(this, tr("Calculate Radius"),
			 tr("theta %1 >= 90 deg.\ntake no action").arg(buffer));
  else
    {
      rho= 2.0* source* image* cos(theta * PI/180.0)/ (source+ image); 
      sprintf(buffer, "%9.3f", rho);
      rhoE->setText(QString(tr(buffer)));
    }
 
} // rhoBslot

void MainWindow::rBslot()
{
  double theta, rmi, source, image;
  char buffer[10];
  
  sscanf(thetaE ->text().toAscii().data(), "%lf", &theta);  // get theta  from widget text buffer
  sscanf(sourceE->text().toAscii().data(), "%lf", &source); // get source from widget text buffer
  sscanf(imageE ->text().toAscii().data(), "%lf", &image);  // get image  from widget text buffer

  sprintf(buffer, "%9.3f", theta); // for message box

  if (theta >= 90.0)
    QMessageBox::warning(this, tr("Calculate Radius"),
			 tr("theta %1 >= 90 deg.\ntake no action").arg(buffer));
  else
    {
      rmi= (2.0* source* image)/ ((source+ image)* cos(theta * PI/180.0)); 
      sprintf(buffer, "%9.3f", rmi);
      rE->setText(QString(tr(buffer)));
    }
} // rBslot  
// end calc slots

// debug
void MainWindow::debugslot()
{
  printf("debugslot activated\n");
}

//
// UF slot delete optical element in the beamline box
//
void MainWindow::deleteElement()
{
  struct ElementType *tmplist, *listpt, *tmplistpt;
  QListWidgetItem *item;
  int i;
  int pos= elementList->currentRow();
  //  char *text;

#ifdef DEBUG
  printf("deleteElement: delete element with idx %d out of %u\n", pos, this->elementzahl);
#endif

  if (pos >= 0)
    {
      item= elementList->takeItem(pos);
      this->elementzahl= this->elementList->count();
      if (item)
	{
	  printf("remove item %d, new count: %d\n", pos, this->elementzahl);
	  delete item;
	} 
      else 
	printf("item unvalid \n");
      
      
      //#ifdef XXX
      printf ("widget deleted\n");
      tmplist= XMALLOC(struct ElementType, this->elementzahl); // alloc memory
      memcpy(tmplist, this->ElementList, this->elementzahl* sizeof(struct ElementType)); // copy contents
      
      if (this->elementzahl == 0) 
	XFREE(this->ElementList);
      else
	this->ElementList= XREALLOC(struct ElementType, this->ElementList, this->elementzahl);
      
      /* umsortieren */
      listpt= this->ElementList; tmplistpt= tmplist; 
      for (i= 1; i<= (int)this->elementzahl; i++, listpt++)
	{
	  if (i == pos)  tmplistpt++;  /* ueberlesen */
	  memcpy(listpt, tmplistpt++, sizeof(struct ElementType)); 
	}
      this->beamlineOK &= ~(mapOK | resultOK);
      //  WriteBLFile(PHASESet.beamlinename, bl); 
      XFREE(tmplist);
      //#endif
      printf("done\n");
    } 
  else
    QMessageBox::warning(this, tr("deleteElement"),
			 tr("can't delete anything, list is empty or nothing is selected!\n"));
  UpdateStatus();
  writeBackupFile();
} // deleteElement()

// slot changed dispersive length
void MainWindow::dislenSlot()
{
#ifdef DEBUG
  printf("dislenSlot called\n");
#endif
  sscanf(dislenE->text().toAscii().data(), "%lf", &this->BLOptions.displength);
  this->beamlineOK &= ~resultOK;
  UpdateStatus();
  writeBackupFile();
} // dislenSlot

// UF slot
void MainWindow::doubleclickElement()
{
  printf("doubleclickElement: called \n");
} // doubleclickElement

// apply slot for optical element
void MainWindow::elementApplyBslot()
{
  int number= elementList->currentRow();
  //char buffer[MaxPathLength];

  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			 tr("(nothing selected)"));
      return;
    }

  struct gdatset *gd= &(this->ElementList[number].GDat);
  struct mdatset *md= &(this->ElementList[number].MDat);

  this->beamlineOK &= ~mapOK;
  this->beamlineOK &= ~resultOK;
  this->ElementList[number].ElementOK = 0;

  strcpy(this->ElementList[number].elementname, elementList->currentItem()->text().toAscii().data()); // the name of the element
  
  printf("elementApplyBslot activated\nfeed data from widget into dataset\n");

#ifdef DEBUG
  printf("elementApplyBslot activated\n");
#endif

  sscanf(preE   ->text().toAscii().data(), "%lf", &gd->r);  
  sscanf(sucE   ->text().toAscii().data(), "%lf", &gd->rp);
  sscanf(thetaE ->text().toAscii().data(), "%lf", &gd->theta0);       
  sscanf(sourceE->text().toAscii().data(), "%lf", &md->r1);   
  sscanf(imageE ->text().toAscii().data(), "%lf", &md->r2);
  sscanf(rE     ->text().toAscii().data(), "%lf", &md->rmi);          
  sscanf(rhoE   ->text().toAscii().data(), "%lf", &md->rho);  
  sscanf(lineDensity->text().toAscii().data(), "%lf", &gd->xdens[0]);
  sscanf(vls1->text().toAscii().data(), "%lf", &gd->xdens[1]);
  sscanf(vls2->text().toAscii().data(), "%lf", &gd->xdens[2]);
  sscanf(vls3->text().toAscii().data(), "%lf", &gd->xdens[3]);
  sscanf(vls4->text().toAscii().data(), "%lf", &gd->xdens[4]);
  
  sscanf(duE ->text().toAscii().data(), "%lf", &md->du);
  sscanf(dwE ->text().toAscii().data(), "%lf", &md->dw);
  sscanf(dlE ->text().toAscii().data(), "%lf", &md->dl);
  sscanf(dRuE->text().toAscii().data(), "%lf", &md->dRu);
  sscanf(dRwE->text().toAscii().data(), "%lf", &md->dRw);
  sscanf(dRlE->text().toAscii().data(), "%lf", &md->dRl);
  sscanf(w1E ->text().toAscii().data(), "%lf", &md->w1);
  sscanf(w2E ->text().toAscii().data(), "%lf", &md->w2);
  sscanf(wsE ->text().toAscii().data(), "%lf", &md->slopew);
  sscanf(l1E ->text().toAscii().data(), "%lf", &md->l1);
  sscanf(l2E ->text().toAscii().data(), "%lf", &md->l2);
  sscanf(lsE ->text().toAscii().data(), "%lf", &md->slopel);
  md->dRu*= 1e-3;
  md->dRw*= 1e-3;
  md->dRl*= 1e-3;
  gd->inout= integerSpinBox->value();
  gd->iflag= (nimBox->isChecked() == true) ? 1 : 0;
  // build the element
  DefMirrorC(md,   &(this->ElementList[number].mir), md->Art, gd->theta0, this->BLOptions.REDUCE_maps);
  DefGeometryC(gd, &(this->ElementList[number].geo));
  MakeMapandMatrix(&(this->ElementList[number]), this);
  //  this->ElementList[number].ElementOK |= elementOK;
  UpdateStatus();
  writeBackupFile();
} // elementApplyBslot

// sigmabutton 
void MainWindow::fwhmslot()
{
#ifdef DEBUG
  printf("debug: fwhmslot called\n");
#endif
  d_plot->fwhmon= 1;
} // fwhmslot


// slot goButton
void MainWindow::goButtonslot()
{
#ifdef DEBUG
  printf("debug: goButtonslot called\n");
#endif

  this->BLOptions.SourcetoImage= 1;
  this->beamlineOK &= ~resultOK;
  UpdateStatus();
  writeBackupFile();
} // goButtonslot


// gr apply
void MainWindow::grapplyslot()
{
#ifdef DEBUG
  printf("debug: grapplyslot called\n");
#endif

  if (!d_plot)
    {
      printf("debug: grapplyslot: d_plot not defined\n");
      return;
    }

  sscanf(gryminE->text().toAscii().data(), "%lf", &d_plot->Plot::ymin);
  sscanf(grymaxE->text().toAscii().data(), "%lf", &d_plot->Plot::ymax);
  sscanf(grzminE->text().toAscii().data(), "%lf", &d_plot->Plot::zmin);
  sscanf(grzmaxE->text().toAscii().data(), "%lf", &d_plot->Plot::zmax);

  if (d_plot->plotsubject == 0) 
    if (this->beamlineOK & sourceOK)
      {
	d_plot->Plot::hfill((struct RayType *)this->RTSource.SourceRays, this->RTSource.raynumber);
	d_plot->Plot::statistics((struct RayType *)this->RTSource.SourceRays, this->RTSource.raynumber, this->deltalambdafactor);
	UpdateStatistics(d_plot, "Source", this->RTSource.raynumber);
	d_plot->setTitle(tr("Source Plane"));
	d_plot->setphaseData("grsourceAct");
      }
    else
      QMessageBox::warning(this, tr("grapplyslot"), tr("No source data available"));
  
  if (d_plot->plotsubject == 1) 
    if (this->beamlineOK & resultOK)
      {
	d_plot->Plot::hfill((struct RayType *)this->RESULT.RESp, this->RESULT.points);
	d_plot->Plot::statistics((struct RayType *)this->RESULT.RESp, this->RESULT.points, this->deltalambdafactor);
	UpdateStatistics(d_plot, "Image", this->RESULT.points);
	d_plot->setTitle(tr("Image Plane"));
	d_plot->setphaseData("grimageAct");
      }
    else
      QMessageBox::warning(this, tr("grapplyslot"), tr("No valid results available"));
  
  if (d_plot->plotsubject == 2) 
    {
      d_plot->setTitle(tr("PhaseQt: example 1"));
      d_plot->setdefaultData();
    }
  
  if (d_plot->plotsubject == 3) 
    {
      d_plot->setTitle(tr("PhaseQt: example 2"));
      d_plot->setdefaultData2();
    }
#ifdef DEBUG
  printf("debug: grapplyslot end with replot\n");
#endif
  d_plot->replot();
} // grapply

// slot autscale
void MainWindow::grautoscaleslot()
{
  char buffer[10];

#ifdef DEBUG
  printf("debug: grautoscaleslot called\n");
#endif

  if (d_plot->plotsubject == 1) 
    if (this->beamlineOK & resultOK)
      d_plot->Plot::autoScale((struct RayType *)this->RESULT.RESp, this->RESULT.points); 
    else
      QMessageBox::warning(this, tr("grautoscaleslot"), tr("No results available"));
			
  if (d_plot->plotsubject == 0) 
    if (this->beamlineOK & sourceOK)
      d_plot->Plot::autoScale((struct RayType *)this->RTSource.SourceRays, this->RTSource.raynumber);
    else
      QMessageBox::warning(this, tr("grautoscaleslot"), tr("No source data available"));
  
  sprintf(buffer, "%9.3f", d_plot->Plot::ymin);
  gryminE->setText(QString(tr(buffer)));
  sprintf(buffer, "%9.3f", d_plot->Plot::ymax);
  grymaxE->setText(QString(tr(buffer)));
  sprintf(buffer, "%9.3f", d_plot->Plot::zmin);
  grzminE->setText(QString(tr(buffer)));
  sprintf(buffer, "%9.3f", d_plot->Plot::zmax);
  grzmaxE->setText(QString(tr(buffer)));
} // end slot autoscale

// slot grating
void MainWindow::grslot()
{
  int number= elementList->currentRow();

#ifdef DEBUG
  printf("debug: grslot called\n");
#endif

  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			 tr("(nothing selected)"));
      return;
    }

  if (gratingGroup->isChecked() == true)
    this->ElementList[number].MDat.Art |= GRATINGBIT; 
  else
    this->ElementList[number].MDat.Art &= ~(GRATINGBIT); 

  UpdateElementBox(number);
} // grslot

// slot grating vls
void MainWindow::grvlsslot()
{
  int number= elementList->currentRow();

#ifdef DEBUG
  printf("debug: grvlsslot called\n");
#endif

  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			 tr("(nothing selected)"));
      return;
    }

  if (vlsGroup->isChecked() == true)
    this->ElementList[number].MDat.Art |= VLSBIT ; 
  else
    this->ElementList[number].MDat.Art &= ~(VLSBIT) ;
 
  UpdateElementBox(number);
} // end grvlsslot

// UF slot insert a new optical element in the beamline box
void MainWindow::insertElement()
{

#ifdef DEBUG
  printf("debug: insertElement called\n");
#endif


  struct ElementType *tmplist, *listpt, *tmplistpt;
  int i;
  int pos= elementList->currentRow();
  if (pos < 0) pos= 0;  // empty list 
  if (abs(this->elementzahl) > 1000) this->elementzahl= 0;  // fix falls elementzahl nicht initialisiert

#ifdef DEBUG
  printf("AddBLElement: AddItem at pos %d, out of %u\n", pos, this->elementzahl);  
#endif 
 
  QListWidgetItem *item= new QListWidgetItem("New Element");
  elementList->insertItem(pos, item);
  item->setFlags (item->flags () | Qt::ItemIsEditable);               // edit item
  tmplist= XMALLOC(struct ElementType, this->elementzahl); // alloc memory
  memcpy(tmplist, this->ElementList, this->elementzahl* sizeof(struct ElementType)); // copy contents
  this->elementzahl++;
  this->ElementList= XREALLOC(struct ElementType, this->ElementList, this->elementzahl);
  listpt= this->ElementList; tmplistpt= tmplist; 
  for (i= 0; i< (int)this->elementzahl; i++, listpt++)
    {
#ifdef DEBUG
      printf("i= %d, pos= %d, nmax %u\n", i, pos, this->elementzahl);
#endif
      if (i == pos)
	{
	  listpt->ElementOK= 0;
	  sprintf(listpt->elementname, "%s", "New Element");
	  minitdatset(&listpt->MDat);
	  listpt->MDat.Art= kEOETM;   // overwrite kEOEDefaults
	  ginitdatset(&listpt->GDat);
	  
	}
      else
	memcpy(listpt, tmplistpt++, sizeof(struct ElementType)); 
    }
  this->beamlineOK &= ~(mapOK | resultOK);
  //  WriteBLFile(PHASESet.beamlinename, bl); 
  XFREE(tmplist);
  printf("inserElement: end list should have %u elements\n", this->elementzahl);
} // insertElement

// slot changed  lambda
void MainWindow::lambdaSlot()
{
#ifdef DEBUG
  printf("lambdaSlot called\n");
#endif

  unsigned int i;
  sscanf(lambdaE->text().toAscii().data(), "%lf", &this->BLOptions.lambda);
  this->BLOptions.lambda*= 1e-6;
  this->beamlineOK= 0;
  for (i=0; i< this->elementzahl; i++) this->ElementList[i].ElementOK= 0;
  UpdateStatus();
} // lambdaSlot

// misaliBoxslot
void MainWindow::misaliBoxslot(int newstate)
{
#ifdef DEBUG
  printf("misaliBoxslot called: new state: %d\n", newstate);
#endif
  
  this->BLOptions.WithAlign= (newstate == Qt::Checked) ? 1 : 0;
} // misaliBoxslot

// slot called to read in a new beamline
void MainWindow::newBeamline()
{
  // int rcode;
  const char *name= "new_beamline.phase";

  if ( fexists((char *)name)) 
    QMessageBox::warning(this, tr("Phase: newBeamline"),
			 tr("File %1. already exists but we do not read it!\n 'Save as' will overwite it!").arg(name));
  
  this->beamlineOK= 0;
  this->myPHASEset::init(name);
  PutPHASE(this, (char*) MainPickName);
  this->RTSource.QuellTyp = 'H';                /* set default Quelltyp   */
  AllocRTSource(this);                          /* reserves source memory */
  this->RTSource.raynumber= 0;                  /* set default raynumber  */
  XFREE(RTSource.SourceRays);
  this->elementzahl = 0; 
  XFREE(this->ElementList);                     /* clean up memory of elements  */
  this->RESULT.points= 0;
  FreeResultMem(&this->RESULT);
  this->BLOptions.lambda= 3.1e-6;                /* 400 ev */
  this->BLOptions.displength= 5000;
  this->BLOptions.SourcetoImage= 1;
  this->BLOptions.WithAlign= 0;
  UpdateElementList();
  UpdateBeamlineBox();
  UpdateSourceBox();
  parameterUpdateAll(NPARS);
  statusBar()->showMessage(tr("New Beamline '%1' created!").arg(name), 4000);
} // end newBeamline()

// slot called to read in a new beamline
void MainWindow::openBeamline()
{
  int rcode;
  
#ifdef DEBUG
  printf("Debug: slot openBeamline activated\n");
  //  myQtPhase->myPHASEset::print();
#endif
  QString fileName = QFileDialog::getOpenFileName(this, tr("Open File"), 
						  QDir::currentPath(),
						  //"/afs/psi.ch/user/f/flechsig/phase/data",
						  tr("Phase files (*.phase);;(*)")
						  );
  char *name;
  //  int result;
  //this->QtPhase::print();

  if (!fileName.isEmpty()) 
    {
      name= fileName.toAscii().data();
      printf("MainWindow::newBeamline: try to read file: %s\n", name);
      rcode= ReadBLFile(name, this);
      if (rcode != -1)
	{
	  this->myPHASEset::init(name);
	  UpdateElementList();
	  UpdateBeamlineBox();
	  UpdateSourceBox();
	  parameterUpdateAll(NPARS);
	  this->beamlineOK= 0;
	  PutPHASE(this, (char*) MainPickName);
	} 
      else
	QMessageBox::information(this, tr("Phase: newBeamline"),
				 tr("Cannot load %1.\n wrong file type!").arg(fileName));
    }
  //this->myPHASEset::print();
  UpdateStatus();
} // end openBeamline()

// slot parameter update, callback des Editors
void MainWindow::parameterUpdateSlot()
{
  unsigned int i;
#ifdef DEBUG
  printf("debug: parameterUpdateSlot called, file: %s\n", __FILE__);
#endif
  parameterUpdate(parameterList->currentRow(), parameterE->text().toAscii().data(), 0);
  this->beamlineOK &= ~mapOK;
  this->beamlineOK &= ~resultOK;
  for (i=0; i< this->elementzahl; i++) this->ElementList[i].ElementOK= 0;
  UpdateStatus();
  writeBackupFile();
} // end parameterUpdateSlot

// slot goButton
void MainWindow::poButtonslot()
{
#ifdef DEBUG
  printf("poButtonslot called\n");
#endif

  this->BLOptions.SourcetoImage= 2;
  this->beamlineOK &= ~resultOK;
  UpdateStatus();
  writeBackupFile();
} // poButtonslot


// slot orientation radio buttons
void MainWindow::rup1slot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			 tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].GDat.azimut= 0;
  this->ElementList[number].GDat.theta0= fabs(this->ElementList[number].GDat.theta0);
  UpdateElementBox(number);
}

void MainWindow::rleft2slot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].GDat.azimut= 1;
  this->ElementList[number].GDat.theta0= fabs(this->ElementList[number].GDat.theta0);
  UpdateElementBox(number);
}

void MainWindow::rdown3slot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].GDat.azimut= 2;
  this->ElementList[number].GDat.theta0= -fabs(this->ElementList[number].GDat.theta0);
  UpdateElementBox(number);
}

void MainWindow::rright4slot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].GDat.azimut= 3;
  this->ElementList[number].GDat.theta0= -fabs(this->ElementList[number].GDat.theta0);
  UpdateElementBox(number);
} 
// end slot orientation radio buttons

// slot
void MainWindow::print()
{
#ifdef DEBUG
  std::cout << "debug: MainWindow::print called \n";
#endif

#ifndef QT_NO_PRINTDIALOG
  //QTextDocument *document = textEdit->document();
    QPrinter printer;

    QPrintDialog *dlg = new QPrintDialog(&printer, this);
    if (dlg->exec() != QDialog::Accepted)
        return;

    //  document->print(&printer);
    d_plot->printPlot();
    statusBar()->showMessage(tr("Ready"), 4000);
#endif
} // end print()

// slot
void MainWindow::save()
{
  char *name= this->beamlinename;

  WriteBLFile(name, this);
 

  statusBar()->showMessage(tr("Saved '%1'").arg(name), 4000);
} // end save

// slot
void MainWindow::saveas()
{
    char *name;
    QString fileName = QFileDialog::getSaveFileName(this,
                        tr("Choose a file name"), ".",
                        tr("PHASE (*.phase)"));
    if (fileName.isEmpty())
        return;

    name= fileName.toAscii().data();

    QFile file(fileName);
    if (!file.open(QFile::WriteOnly | QFile::Text)) {
        QMessageBox::warning(this, tr("PHASE Qt"),
                             tr("Cannot write file %1:\n%2.")
                             .arg(fileName)
                             .arg(file.errorString()));
        return;
    }
    this->myPHASEset::init(name);
    PutPHASE(this, (char*) MainPickName);
    WriteBLFile(name, this);
    UpdateBeamlineBox();
    //    QTextStream out(&file);
    //    QApplication::setOverrideCursor(Qt::WaitCursor);
    //    out << textEdit->toHtml();
    //   QApplication::restoreOverrideCursor();

    statusBar()->showMessage(tr("Saved '%1'").arg(fileName), 4000);
} // end save

// UF selection slot
void MainWindow::selectElement()
{
#ifdef DEBUG
  printf("debug: selectElement called\n");
#endif
  QListWidgetItem *item;
  int elementnumber= elementList->currentRow();
  char *text;
  
  if (elementnumber < 0) 
    return;

  item= elementList->currentItem();
  text= item->text().toAscii().data();
  elementnumber= elementList->currentRow();
  groupBox1->setTitle(item->text());  // set text header
  UpdateElementBox(elementnumber);
} // selectElement

// UF selection slot
void MainWindow::selectParameter()
{
#ifdef DEBUG
  printf("debug: selectParameter called\n");
#endif
  char buffer[MaxPathLength], *ch;
  int parameternumber= parameterList->currentRow();
  
  if (parameternumber < 0) 
    return;

  strcpy(buffer, parameterList->currentItem()->text().toAscii().data());
  ch= strchr(buffer, ':');
  if (ch != NULL) 
    {
      *ch= '\0';
      parameterE->setText(buffer);
    }
 } // selectParameter

// slot shapeMenu
// slot shapeMenu plane mirror
void MainWindow::pmslot()
{
  int number= elementList->currentRow();
if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			 tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].MDat.Art= kEOEPM;
  this->ElementList[number].MDat.rmi= 0.0;
  this->ElementList[number].MDat.rho= 0.0;
  UpdateElementBox(number);
}

// slot shapeMenu toroidal mirror
void MainWindow::toslot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].MDat.Art= kEOETM;
  UpdateElementBox(number); 
}

// slot shapeMenu plane elliptical mirror
void MainWindow::peslot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].MDat.Art= kEOEPElli;
  UpdateElementBox(number); 
}

// slot shapeMenu elliptical mirror
void MainWindow::elslot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].MDat.Art= kEOEElli;
  UpdateElementBox(number); 
}

// slot shapeMenu conical mirror
void MainWindow::coslot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].MDat.Art= kEOECone;
  UpdateElementBox(number); 
}

// slot shapeMenu generic shape
void MainWindow::geslot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].MDat.Art= kEOEGeneral;
  QMessageBox::information(this, tr("gerneric element slot"),
			   tr("The elementname must be the file name!\nsave and reload the beamline!"));
  UpdateElementBox(number); 
}

// slot shapeMenu generic shape
void MainWindow::apslot()
{
  int number= elementList->currentRow();
  if (number < 0) 
    {
      QMessageBox::warning(this, tr("No valid dataset!"),
			   tr("(nothing selected)"));
      return;
    }
  this->ElementList[number].MDat.Art= kEOESlit;
  UpdateElementBox(number); 
}
// end slots shapeMenu


// sigmabutton 
void MainWindow::sigmaslot()
{
#ifdef DEBUG
  printf("debug: sigmaslot called\n");
#endif
  d_plot->fwhmon= 0;
} // sigmaslot

// apply slot for source
void MainWindow::sourceDefaultBslot()
{
#ifdef DEBUG
  printf("sourceDefaultBslot activated\n");
#endif
  //sourceSetDefaults();
  oldsource='0';    // something not valid
  UpdateSourceBox();
  //  QMessageBox::warning(this, tr("sourceDefaultBslot"),
  //			   tr("no function so far"));
} // end sourceDefaultBslot


// apply slot for source
void MainWindow::sourceApplyBslot()
{
  int sou;
  double lambda;
  struct UndulatorSourceType  *up;
  struct UndulatorSource0Type *up0;
  struct DipolSourceType      *dp;
  struct PointSourceType      *sop;
  struct RingSourceType       *rp;
  struct HardEdgeSourceType   *hp;     
  //struct SRSourceType         *sp; 
  //struct PSImageType          *psip;
  //struct PSSourceType         *pssp; 

#ifdef DEBUG
  printf("sourceApplyBslot activated\n");
#endif

  if (RTSource.Quellep == NULL )
    {
      printf("error: sourceApplyBslot: Quellep == NULL\n");
      return;
    }
    
  sou= this->RTSource.QuellTyp;
  switch (sou) {
    
  case 'D':
    dp= (struct DipolSourceType *)this->RTSource.Quellep;
    sscanf(S1E->text().toAscii().data(), "%lf", &dp->sigy);
    sscanf(S2E->text().toAscii().data(), "%lf", &dp->sigdy);
    sscanf(S3E->text().toAscii().data(), "%lf", &dp->sigz);
    sscanf(S4E->text().toAscii().data(), "%lf", &dp->dz);
    sscanf(S5E->text().toAscii().data(), "%d",  &this->RTSource.raynumber);
    break;
    
  case 'G':
    up0= (struct UndulatorSource0Type *)this->RTSource.Quellep;
    sscanf(S1E->text().toAscii().data(), "%lf", &up0->length);
    sscanf(S2E->text().toAscii().data(), "%lf", &lambda);
    sscanf(S3E->text().toAscii().data(), "%d",  &this->RTSource.raynumber);
    sscanf(S4E->text().toAscii().data(), "%lf", &up0->deltaz);
    sscanf(S5E->text().toAscii().data(), "%lf", &up0->sigmaey);
    sscanf(S6E->text().toAscii().data(), "%lf", &up0->sigmaez);
    sscanf(S7E->text().toAscii().data(), "%lf", &up0->sigmaedy);
    sscanf(S8E->text().toAscii().data(), "%lf", &up0->sigmaedz);
    break;
    
  case 'H':
    hp= (struct  HardEdgeSourceType *)this->RTSource.Quellep;
    sscanf(S1E->text().toAscii().data(), "%lf", &hp->disty);
    sscanf(S2E->text().toAscii().data(), "%d",  &hp->iy);
    sscanf(S3E->text().toAscii().data(), "%lf", &hp->distz);
    sscanf(S4E->text().toAscii().data(), "%d",  &hp->iz);
    sscanf(S5E->text().toAscii().data(), "%lf", &hp->divy);
    sscanf(S6E->text().toAscii().data(), "%d",  &hp->idy);
    sscanf(S7E->text().toAscii().data(), "%lf", &hp->divz);
    sscanf(S8E->text().toAscii().data(), "%d",  &hp->idz);
    this->RTSource.raynumber=  hp->iy* hp->idy* hp->iz* hp->idz;
    break;
    
  case 'L':
  case 'M':
    up= (struct UndulatorSourceType *)this->RTSource.Quellep;
    sscanf(S1E->text().toAscii().data(), "%lf", &up->length);
    sscanf(S2E->text().toAscii().data(), "%lf", &lambda);
    sscanf(S3E->text().toAscii().data(), "%d",  &this->RTSource.raynumber);
    sscanf(S4E->text().toAscii().data(), "%lf", &up->deltaz);
    break;
    
  case 'o':
    sop= (struct PointSourceType *)this->RTSource.Quellep;
    sscanf(S1E->text().toAscii().data(), "%lf", &sop->sigy);
    sscanf(S2E->text().toAscii().data(), "%lf", &sop->sigdy);
    sscanf(S3E->text().toAscii().data(), "%lf", &sop->sigz);
    sscanf(S4E->text().toAscii().data(), "%lf", &sop->sigdz);
    sscanf(S5E->text().toAscii().data(), "%d",  &this->RTSource.raynumber);
    break;
    
  case 'R':
    rp= (struct RingSourceType *)this->RTSource.Quellep;
    sscanf(S1E->text().toAscii().data(), "%lf", &rp->dy);
    sscanf(S2E->text().toAscii().data(), "%lf", &rp->dz);
    sscanf(S3E->text().toAscii().data(), "%d",  &this->RTSource.raynumber);
    break;
    
  case 'U':
    up= (struct UndulatorSourceType *)this->RTSource.Quellep;
    sscanf(S1E->text().toAscii().data(), "%lf", &up->length);
    sscanf(S2E->text().toAscii().data(), "%lf", &lambda);
    sscanf(S3E->text().toAscii().data(), "%d",  &this->RTSource.raynumber);
    break;
  case 'F':
    // hier muss nichts gemacht werden
    break;
    
  default:
    QMessageBox::warning(this, tr("sourceApplyBslot"),
			 tr("Source type %1 not recognized.\nreport bug to uwe.flechsig@psi.ch")
			 .arg(sou));
    return;
  }

  this->BLOptions.wrSource = (sourceFileBox->isChecked() == true) ?  1 : 0;  
  MakeRTSource(this, this);
  this->beamlineOK &= ~resultOK;
  UpdateStatus();
  writeBackupFile();
} //sourceApplyBslot

// slot
void MainWindow::undo()
{
  //QTextDocument *document = textEdit->document();
  //  document->undo();
} // undo

///////////////////////
// end slots section //
///////////////////////


// end /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/mainwindow_slots.cpp
