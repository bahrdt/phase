//  File      : /afs/psi.ch/user/f/flechsig/phase/src/qtgui/plot.cpp
//  Date      : <29 Jun 11 16:12:43 flechsig> 
//  Time-stamp: <20 Jun 12 14:22:47 flechsig> 
//  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104;

//  $Source$ 
//  $Date$
//  $Revision$ 
//  $Author$ 

// taken from qwt examples

#include <QtGui>

#include <qprinter.h>
#include <qprintdialog.h>
#include <qwt_color_map.h>
//#include <qwt_plot_spectrom.h>
#include <qwt_scale_widget.h>
#include <qwt_scale_draw.h>
#include <qwt_plot_zoomer.h>
#include <qwt_plot_panner.h>
#include <qwt_plot_layout.h>
#include <qwt_plot_renderer.h>
#include <qwt_plot_curve.h>
#include <qwt_plot_grid.h>
#include <qwt_legend.h>
#include <qwt_plot.h>
#include <qwt_plot_canvas.h>
#include <qwt_symbol.h>
#include <qwt_plot_directpainter.h>
#include <qpaintengine.h>
//#include <qapplication.h>
//#include <qpen.h>
//#include <qwt_data.h>

#include "plot.h"
#include "myzoomer.h"
#include "phaseqt.h"
#include "plotmatrix.h"

using namespace std;   // fuer cout z.B.

class CurveData: public QwtArraySeriesData<QPointF>
{
public:
    CurveData()
    {
    }

    virtual QRectF boundingRect() const
    {
        if ( d_boundingRect.width() < 0.0 )
            d_boundingRect = qwtBoundingRect( *this );

        return d_boundingRect;
    }

    inline void append( const QPointF &point )
    {
        d_samples += point;
    }

    void clear()
    {
        d_samples.clear();
        d_samples.squeeze();
        d_boundingRect = QRectF( 0.0, 0.0, -1.0, -1.0 );
    }
};

// UF the original 2d data
class SpectrogramData: public QwtRasterData
{
public:
    SpectrogramData()
    {
        setInterval( Qt::XAxis, QwtInterval( -1.5,  1.5 ) );
        setInterval( Qt::YAxis, QwtInterval( -1.5,  1.5 ) );
        setInterval( Qt::ZAxis, QwtInterval(  0.0, 10.0 ) );
    }

    virtual double value(double x, double y) const
    {
        const double c = 0.842;

        const double v1 = x * x + (y-c) * (y+c);
        const double v2 = x * (y+c) + x * (y+c);

        return 1.0 / (v1 * v1 + v2 * v2);
    }
};

// UF my copy of the 2d data with slightly changed patrameters
class SpectrogramData2: public QwtRasterData
{
public:
    SpectrogramData2()
    {
        setInterval( Qt::XAxis, QwtInterval( -2.5,  3.5 ) );
        setInterval( Qt::YAxis, QwtInterval( -2.5,  3.5 ) );
        setInterval( Qt::ZAxis, QwtInterval(  0.0, 22.0 ) );
    }

    virtual double value(double x, double y) const
    {
        const double c = 0.542;

        const double v1 = x * x + (y-c) * (y+c);
        const double v2 = x * (y+c) + x * (y+c);

        return 1.0 / (v1 * v1 + v2 * v2);
    }
};

// keeps the 2d PO data
class SpectrogramDataPO: public QwtRasterData
{
private:
  Plot   *po;
  double dxtotal;
  double dytotal;
  
public:
    SpectrogramDataPO(Plot *plotobj)
    {
      po= plotobj;
      dxtotal= po->pox[po->h2a_nx- 1] - po->pox[0];
      dytotal= po->poy[po->h2a_ny- 1] - po->poy[0];
      
#ifdef DEBUG
      printf("debug: constructor SpectrogramDataPO: zmin %f zmax %f h2max: %f", po->zmin, po->zmax,  po->h2max);
      //      printf("debug: h2a_nx= %d, h2a_ny= %d\n ", po->h2a_nx, po->h2a_ny);
#endif
      //QwtRasterData(QwtDoubleRect(zmin, zmax, ymin, ymax));
      setInterval( Qt::XAxis, QwtInterval( po->zmin, po->zmax ) );
      setInterval( Qt::YAxis, QwtInterval( po->ymin, po->ymax ) );
      setInterval( Qt::ZAxis, QwtInterval( 0.0, 10. ) );
#ifdef DEBUG
      cout << " ==> done"  << endl;
#endif
    }
  
    virtual double value(double x, double y) const
    {
      int ix = qRound((po->h2a_nx- 1)* (x- po->pox[0])/ dxtotal);
      int iy = qRound((po->h2a_ny- 1)* (y- po->poy[0])/ dytotal);
      if ( ix >= 0 && ix < po->h2a_nx && iy >= 0 && iy < po->h2a_ny )
	return po->h2a[ix+ iy* po->h2a_nx];
      return 10.0; // should never happen
    }
};

// keeps the 2d PO data
class SpectrogramDataGO: public QwtRasterData
{
private:
  Plot   *po;
  
public:
    SpectrogramDataGO(Plot *plotobj)
    {
      po= plotobj;
      
#ifdef DEBUG
      printf("debug: constructor SpectrogramDataGO: zmin %f zmax %f h2max: %f", po->zmin, po->zmax,  po->h2max);
      //   printf("debug: h2a_nx= %d, h2a_ny= %d\n ", po->h2a_nx, po->h2a_ny);
#endif
      //QwtRasterData(QwtDoubleRect(zmin, zmax, ymin, ymax));
      setInterval( Qt::XAxis, QwtInterval( po->zmin, po->zmax ) );
      setInterval( Qt::YAxis, QwtInterval( po->ymin, po->ymax ) );
      setInterval( Qt::ZAxis, QwtInterval( 0.0, 10. ) );
#ifdef DEBUG
      cout << " ==> done"  << endl;
#endif
    }
  
    virtual double value(double x, double y) const
    {
      int ix = qRound((po->h2a_nx- 1)* (x- po->zmin)/(po->zmax - po->zmin));
      int iy = qRound((po->h2a_ny- 1)* (y- po->ymin)/(po->ymax - po->ymin));
      if ( ix >= 0 && ix < po->h2a_nx && iy >= 0 && iy < po->h2a_ny )
	return po->h2a[ix+ iy* po->h2a_nx];
      return 10.0; // should never happen
    }
};


class ColorMap: public QwtLinearColorMap
{
public:
    ColorMap(): QwtLinearColorMap(Qt::darkCyan, Qt::red)
    {
        addColorStop(0.1,  Qt::cyan);
        addColorStop(0.6,  Qt::green);
        addColorStop(0.95, Qt::yellow);
    }
};

// constructor of the plot
// parent is a pointer to the  mainwindow object 
Plot::Plot(QWidget *parent): QwtPlot(parent)
{
  //d_directPainter = new QwtPlotDirectPainter( this );  // ev nicht noetig
  d_curve1 = new QwtPlotCurve( "dz min" );               // one curve
  d_curve2 = new QwtPlotCurve( "dz center" );            // one curve
  d_curve1->attach( this ); 
  d_curve2->attach( this ); 
  d_curve1->hide();
  d_curve2->hide();
  
  c1x= c1y= c2x= c2y= h2a= NULL;
  
  d_spectrogram = new QwtPlotSpectrogram();
  d_spectrogram->setRenderThreadCount(0); // use system specific thread count
  
  d_spectrogram->setColorMap(new ColorMap());
  
  d_spectrogram->setData(new SpectrogramData());
  d_spectrogram->attach(this);

  QList<double> contourLevels;
  for ( double level = 0.5; level < 10.0; level += 1.0 )
    contourLevels += level;
  d_spectrogram->setContourLevels(contourLevels);
  
  // const QwtInterval zInterval = d_spectrogram->data()->interval( Qt::ZAxis );
  QwtInterval zInterval = d_spectrogram->data()->interval( Qt::ZAxis );

  // A color bar on the right axis
  QwtScaleWidget *rightAxis = axisWidget(QwtPlot::yRight);
  rightAxis->setTitle("Intensity");
  rightAxis->setColorBarEnabled(true);
  rightAxis->setColorMap( zInterval, new ColorMap());
  
  setAxisScale(QwtPlot::yRight, zInterval.minValue(), zInterval.maxValue() );
  enableAxis(QwtPlot::yRight);
  pen_ptr= new QPen();
  plotLayout()->setAlignCanvasToScales(true);

  replot();
 
  /************ set up zoom *******************/ 
  // LeftButton for the zooming
  // MidButton for the panning
  // RightButton: zoom out by 1
  // Ctrl+RighButton: zoom out to full size
  
  zoomer = new MyZoomer(canvas());
  zoomer->setMousePattern(QwtEventPattern::MouseSelect2,
			  Qt::RightButton, Qt::ControlModifier);
  zoomer->setMousePattern(QwtEventPattern::MouseSelect3,
			  Qt::RightButton);
  
  QwtPlotPanner *panner = new QwtPlotPanner(canvas());
  panner->setAxisEnabled(QwtPlot::yRight, false);
  panner->setMouseButton(Qt::MidButton);
  
  // Avoid jumping when labels with more/less digits
  // appear/disappear when scrolling vertically
  
  const QFontMetrics fm(axisWidget(QwtPlot::yLeft)->font());
  QwtScaleDraw *sd = axisScaleDraw(QwtPlot::yLeft);
  sd->setMinimumExtent( fm.width("100.00") );
  
  const QColor c(Qt::darkBlue);
  zoomer->setRubberBandPen(c);
  zoomer->setTrackerPen(c);

  /************* end zoom *************/
  this->fwhmon= 1;
#ifdef DEBUG  
  cout << "debug: " << __FILE__ << " Plot:constructor called- plotsubject " << plotsubject << endl;
#endif
  //  this->p_zoomer= zoomer;
} // end constructor

Plot::~Plot()
{
#ifdef DEBUG  
  cout << "debug: " << __FILE__ << " Plot:destructor called" <<  endl;
#endif
  if (c1x) XFREE(c1x);
  if (c1y) XFREE(c1y);
  if (c2y) XFREE(c2y);
  if (h2a) XFREE(h2a);
}

void Plot::example3()
{
  getData();
  d_curve1->setRawSamples(c1x, c1y, NPOINTS);
  d_curve2->setRawSamples(c1x, c2y, NPOINTS);
} // example3


// do a contour plot
void Plot::contourPlot()
{
#ifdef DEBUG
  cout << "debug: " << __FILE__ << " contour plot experimental" << endl;
#endif
  d_curve1->hide();
  d_curve2->hide();
  //SetLog(0);
 
  d_spectrogram->show();
  enableAxis(QwtPlot::yRight, true);                 // switch on right axis

  setAxisScale(QwtPlot::yLeft,   ymin, ymax, 0); // manual scaling
  setAxisScale(QwtPlot::xBottom, zmin, zmax, 0); // manual scaling

  if (plotsubject & PLOT_GO_DIV)
    {
      setAxisTitle(2, tr("dz (mrad)"));
      setAxisTitle(0, tr("dy (mrad)"));
    }
  else
    {
      setAxisTitle(2, tr("z (mm)"));
      setAxisTitle(0, tr("y (mm)"));
    }
  
  replot();
} // end contourPlot()


// makes a profile plot
// expects the vectors xxx and yyy to be filled
void Plot::profilePlot(int subject, int style, int nsets)
{
#ifdef DEBUG
  cout << "profile plot subject, style: " << subject << " ," << style << endl;
#endif
  
  d_curve1->hide();
  d_curve2->hide();
  d_spectrogram->hide();
  enableAxis(QwtPlot::yRight, false);                 // switch off right axis
  setCanvasBackground( QColor( 250, 240, 210 ) ); // helles braun in RGB
  d_curve1->setStyle( QwtPlotCurve::Steps ); //Steps Sicks
  pen_ptr->setColor(Qt::red);   // blue
  pen_ptr->setWidth(2);
  d_curve1->setPen(*pen_ptr);

  if (nsets == 2)
    {
      d_curve2->setStyle( QwtPlotCurve::Steps ); //Steps Sicks
      pen_ptr->setColor(Qt::blue);   // blue
      pen_ptr->setWidth(2);
      d_curve2->setPen(*pen_ptr);
    }

  //zoomer->ResetZoomBase();

  /* 2b done */
  // background and line color
  // remove color bar
  // set zoomer
  // deal with log scale
  
  // set labels
  switch (style)
    {
    case PLOT_VPROF:
      if (subject & PLOT_GO_DIV)
	{
	  setAxisTitle(0, tr("dy (mrad)"));
	  setAxisTitle(2, tr("norm. intensity"));
	} 
      else
	{
	  setAxisTitle(0, tr("y (mm)"));
	  setAxisTitle(2, tr("norm. intensity"));
	}
      d_curve1->setRawSamples(c1y, c1x, BINS2);
      if (nsets == 2) d_curve2->setRawSamples(c2y, c2x, BINS2);
      y1= ymin;                                     // for manual scaling
      y2= ymax;             
      x1= ( logscaleon ) ? h1firstgt0 : -(h1max* 0.05); 
      x2= (h1max* 1.05);    
      break;
    case PLOT_HPROF:
      if (subject & PLOT_GO_DIV)
	{
	  setAxisTitle(2, tr("dz (mrad)"));
	  setAxisTitle(0, tr("norm. intensity"));
	} 
      else
	{
	  setAxisTitle(2, tr("z (mm)"));
	  setAxisTitle(0, tr("norm. intensity"));
	}
      d_curve1->setRawSamples(c1x, c1y, BINS2);
      if (nsets == 2) d_curve2->setRawSamples(c2x, c2y, BINS2);
      x1= zmin;           
      x2= zmax;
      y1= ( logscaleon ) ? h1firstgt0 : -(h1max* 0.05); 
      y2= (h1max* 1.05); 
      break; 
    default:
      cout << "error plot.cpp hfill1: unknown type: " << style << endl;
      return;
    }
  
  setAxisScale(QwtPlot::xBottom, x1, x2, 0);   // manual scaling, automatic tics
  setAxisScale(QwtPlot::yLeft,   y1, y2, 0);   // manual scaling
    
  zoomer->setZoomBase(canvas());
  d_curve1->show();
  if (nsets == 2) d_curve2->show();
  replot();
} // end profilePlot()


void Plot::fillData()
{
  printf("fill data called- is empty\n");
} // fillData

// creates the temporary arrays xdata etc out of the ray structure depending on plotsubject
// nsets is the number of datasets in rays, default is 1
void Plot::fillGoPlotArrays(struct RayType *rays, int points, int nsets)
{
  int i;
  struct RayType *rp;

#ifdef DEBUG
  cout << "debug: " << __FILE__ << " fillGoPlotArrays called, plotsubject: " 
       << plotsubject << " ray_sets=" << nsets << endl;
#endif

  ndata= points; // fill private var

  if (c1x) delete c1x; c1x= NULL;
  if (c1y) delete c1y; c1y= NULL;
  if (c2x) delete c2x; c2x= NULL;
  if (c2y) delete c2y; c2y= NULL;
 
  c1x= new double[ndata]; 
  c1y= new double[ndata];

  if ((plotsubject & PLOT_GO_PHI) && (nsets == 1)) c2y= new double[ndata];

  if (nsets == 2) 
    {
      c2x= new double[ndata]; 
      c2y= new double[ndata];
    }

  rp= rays;
  if (plotsubject & PLOT_GO_SPA)
    {
      i= 0;
      while (i< ndata)
	{
	  c1x[i]= rp->z;
	  c1y[i]= rp->y;
	  i++, rp++;
	}
      if (nsets == 2) 
	{
	  i= 0;
	  rp++;
	  while (i< ndata)
	    {
	      c2x[i]= rp->z;
	      c2y[i]= rp->y;
	      i++, rp++;
	    }
	}
    }

  if (plotsubject & PLOT_GO_DIV)
    {
      for (i= 0; i< ndata; i++, rp++)
	{
	 c1x[i]= rp->dz * 1e3; // mrad
	 c1y[i]= rp->dy * 1e3;
	}
    }

  if (plotsubject & PLOT_GO_PHI)
    {
      for (i= 0; i< ndata; i++, rp++)
	{
	  c1x[i]= rp->z;
	  c1y[i]= rp->y;
	  c2y[i]= rp->phi;
	}
    }
} // end fillGoPlotArrays			     

double *Plot::getXdata(int nr)
{
  if (nr != 2) return c1x; else return c2x;
}

double *Plot::getYdata(int nr)
{
  if (nr != 2) return c1y; else return c2y;
}

// makes a scatter plot
void Plot::scatterPlot(int nsets)
{
#ifdef DEBUG   
  cout << "debug: scatter plot" << endl;
#endif
 
  d_spectrogram->hide();                              // hide spectrogram
  d_curve2->hide();                                   // hide curve2
  d_curve1->hide(); 

  //SetLog(0);
  enableAxis(QwtPlot::yRight, false);                 // switch off right axis

  d_curve1->setRawSamples(c1x, c1y, ndata);
  d_curve1->setStyle( QwtPlotCurve::Dots );
  pen_ptr->setColor(Qt::red);   // blue
  pen_ptr->setWidth(2);
  d_curve1->setPen(*pen_ptr);
  setCanvasBackground( QColor( 250, 240, 210 ) ); // helles braun in RGB

  // d_curve1->setStyle( QwtPlotCurve::NoCurve );
  //    d_curve1->setSymbol( new QwtSymbol( QwtSymbol::Ellipse,// QwtSymbol::XCross,
  //        Qt::NoBrush, QPen( Qt::white ), QSize( 2, 2 ) ) );
  // d_curve1->setSymbol( new QwtSymbol( QwtSymbol::XCross,
  //      Qt::NoBrush, QPen( Qt::red ), QSize( 3, 3 ) ) );
  // setCanvasBackground( QColor( 29, 100, 141 ) ); // nice blue
 
  setAxisScale(QwtPlot::xBottom, zmin, zmax, 0); // manual scaling
  setAxisScale(QwtPlot::yLeft,   ymin, ymax, 0); // manual scaling
  zoomer->setZoomBase(canvas());

  d_curve1->show();

  if (nsets == 2)
    {
      d_curve2->setRawSamples(c2x, c2y, ndata);
      d_curve2->setStyle( QwtPlotCurve::Dots );
      pen_ptr->setColor(Qt::blue);   // blue
      pen_ptr->setWidth(2);
      d_curve2->setPen(*pen_ptr);
      d_curve2->show();
    }

  if (plotsubject & PLOT_GO_DIV)
    {
      setAxisTitle(2, tr("dz (mrad)"));
      setAxisTitle(0, tr("dy (mrad)"));
    }
  else
    {
      setAxisTitle(2, tr("z (mm)"));
      setAxisTitle(0, tr("y (mm)"));
    }
  replot();
} // scatterPlot

// plotstyle
void Plot::showContour(bool on)
{
    d_spectrogram->setDisplayMode(QwtPlotSpectrogram::ContourMode, on);
    replot();
}

void Plot::showSpectrogram(bool on)
{
    d_spectrogram->setDisplayMode(QwtPlotSpectrogram::ImageMode, on);
    d_spectrogram->setDefaultContourPen(on ? QPen() : QPen(Qt::NoPen));
    replot();
}

// UF should fill in new data
void Plot::setGoData(const char *datatype)
{
  // struct BeamlineType *bt;
#ifdef DEBUG
  printf("debug: Plot::setphaseData called, datatype: %s\n", datatype);
#endif  

  //delete d_spectrogram->data();   // clean up the old data - correct??
  //printf("delete d_spectrogram->data() ==> done\n");
  
  d_spectrogram->setData(new SpectrogramDataGO(this));
  
  d_spectrogram->show();
  replot();
  zoomer->setZoomBase(canvas());
} // setGoData

// UF should fill in new data
void Plot::setPoData(const char *datatype)
{
  // struct BeamlineType *bt;
#ifdef DEBUG
  printf("debug: Plot::setphaseData called, datatype: %s\n", datatype);
#endif  

  //delete d_spectrogram->data();   // clean up the old data - correct??
  //printf("delete d_spectrogram->data() ==> done\n");
  
  d_spectrogram->setData(new SpectrogramDataPO(this));
  
  d_spectrogram->show();
  replot();
  zoomer->setZoomBase(canvas());
} // setPoData

void Plot::setdefaultData()
{
  delete d_spectrogram->data();
  
  d_spectrogram->setData(new SpectrogramData());
  d_spectrogram->show();
  replot();
  zoomer->setZoomBase(canvas());

} // setdefaultData

void Plot::setdefaultData2()
{
  delete d_spectrogram->data();
  
  QwtRasterData *data = new SpectrogramData2();
  d_spectrogram->setData(data);
  d_spectrogram->show();
  replot();
  zoomer->setZoomBase(canvas());
} // setdefaultData2

#ifndef QT_NO_PRINTER

void Plot::printPlot(QPrinter &printerp )
{
  QwtPlotRenderer renderer;

  renderer.setDiscardFlag(QwtPlotRenderer::DiscardBackground, false);
  renderer.setLayoutFlag(QwtPlotRenderer::KeepFrames, true);
  renderer.renderTo(this, printerp);


 // printerp->setOrientation(QPrinter::Landscape);

#ifdef OLD
#if 1
    QPrinter printer;
#else
    QPrinter printer(QPrinter::HighResolution);
#endif
    printer.setOrientation(QPrinter::Landscape);
    printer.setOutputFileName("spectrogram.pdf");
    QPrintDialog dialog(&printer);
    if ( dialog.exec() )
    {
        QwtPlotRenderer renderer;

        renderer.setDiscardFlag(QwtPlotRenderer::DiscardBackground, false);
        renderer.setLayoutFlag(QwtPlotRenderer::KeepFrames, true);
        renderer.renderTo(this, printer);
    }
#endif
}
#endif

void Plot::autoScale(double z1, double z2, double y1, double y2)   // PO
{
#ifdef DEBUG
  cout << "debug: " << __FILE__ << " PO autoScale called" << endl;
#endif
  ymin= y1;
  ymax= y2;
  zmin= z1;
  zmax= z2;
} // end autoscale PO

void Plot::autoScale(int nsets)   // GO
{
 
  
#ifdef DEBUG
  cout << "debug: " << __FILE__ << "GO autoScale called, ndata: " << ndata << endl;
#endif

  if (ndata > 0) 
    {
      ymin  = ymax  = *c1y;
      zmin  = zmax  = *c1x;
      for (int i= 0; i < ndata; i++)
	{
	  ymin  = min(c1y[i], ymin);
	  ymax  = max(c1y[i], ymax);
	  zmin  = min(c1x[i], zmin); // ! not zdata (zdata only available for phi)
	  zmax  = max(c1x[i], zmax); // ! not zdata
	}
      if (nsets == 2)
	{
	  for (int i= 0; i < ndata; i++)
	    {
	      ymin  = min(c2y[i], ymin);
	      ymax  = max(c2y[i], ymax);
	      zmin  = min(c2x[i], zmin); // ! not zdata (zdata only available for phi)
	      zmax  = max(c2x[i], zmax); // ! not zdata
	    }
	}
    }
  else
    {
      ymin  = -1; ymax  = 1;
      zmin  = -1; zmax  = 1;
    }
  /* fuers Auge */
  Beauty(&ymin,   &ymax);
  Beauty(&zmin,   &zmax);
  
  //printf("autscale: %f, %f\n", ymin, ymax);
#ifdef DEBUG
  printf("DEBUG: autoScale: %lg, %lg, %lg, %lg\n", ymin, ymax, zmin, zmax);
#endif
} //autoScale

// helper function for autoscale
// add 5% border
void Plot::Beauty(double *mi, double *ma) 
{
   double delta;

   delta= fabs(*ma- *mi);

   if (delta > 1e-6)
   {
      *mi-= 0.05 * delta;   
      *ma+= 0.05 * delta;     
   } else 
   {
     if ((fabs(*mi) < ZERO) && (fabs(*ma) < ZERO))
       {
	 *mi= -1e-3;
         *ma=  1e-3;
       }
     else
       {
	 *mi= -1.05 * fabs(*mi);   
	 *ma=  1.05 * fabs(*ma);  
       }
   }
} /* end Beauty */


// fills a 1d histogram with data !! we use c2y
void Plot::hfill1(double *dvec, double x1, double x2, int set)
{
  int i;
  unsigned int ix;
  double *dp;
  
#ifdef DEBUG
  cout << "Plot::hfill1 called" << endl;
#endif

  if ((x2- x1) < ZERO ) x2 = x1 + 1.0;

  if (set != 2)
    {
      if (c1x) delete c1x; c1x= NULL;
      if (c1y) delete c1y; c1y= NULL;
      c1x= new double[BINS2];
      c1y= new double[BINS2];
      for (ix= 0; ix< BINS2; ix++)
	{
	  c1y[ix]= 0.0;
	  c1x[ix]= x1 + ix * (x2- x1)/ BINS2;   // x achse
	}
      
      for (i= 0; i< ndata; i++)
	{
	  ix= (unsigned int)((dvec[i]- x1)/(x2- x1) * BINS2);
	  if ((ix < BINS2) && (ix >= 0)) c1y[ix]+= 1.0;          // add one hit
	} 
    }
  else
    {
      if (c2x) delete c2x; c2x= NULL;
      if (c2y) delete c2y; c2y= NULL;
      c2x= new double[BINS2];
      c2y= new double[BINS2];
      for (ix= 0; ix< BINS2; ix++)
	{
	  c2y[ix]= 0.0;
	  c2x[ix]= x1 + ix * (x2- x1)/ BINS2;   // x achse
	}
      
      for (i= 0; i< ndata; i++)
	{
	  ix= (unsigned int)((dvec[i]- x1)/(x2- x1) * BINS2);
	  if ((ix < BINS2) && (ix >= 0)) c2y[ix]+= 1.0;          // add one hit
	} 
    }
  
 
  h1max= 0.0; h1firstgt0= 1.0;  // ZERO
  if (set != 2)
    {
      if (ndata)                    // not if 0
	{
	  for (ix= 0; ix< BINS2; ix++)
	    {
	      c1y[ix]*= 1.0/ndata;   // density in rays 
	      if (c1y[ix] > h1max) h1max= c1y[ix];
	      if ((c1y[ix] > ZERO) && (c1y[ix] < h1firstgt0)) h1firstgt0 = c1y[ix];
	    }
	  for (ix= 0; ix< BINS2; ix++) 
	    if (c1y[ix] < h1firstgt0 )  c1y[ix]= h1firstgt0;  // fix 0 for log scale
	}
    }
  else
    {
      if (ndata)                    // not if 0
	{
	  for (ix= 0; ix< BINS2; ix++)
	    {
	      c2y[ix]*= 1.0/ndata;   // density in rays 
	      if (c2y[ix] > h1max) h1max= c2y[ix];
	      if ((c2y[ix] > ZERO) && (c2y[ix] < h1firstgt0)) h1firstgt0 = c2y[ix];
	    }
	  for (ix= 0; ix< BINS2; ix++) 
	    if (c2y[ix] < h1firstgt0 )  c2y[ix]= h1firstgt0;  // fix 0 for log scale
	}
    }
  
#ifdef DEBUG
  printf("debug: hfill1 end\n");
#endif
} // hfill1

// fills a 2d histogram with ray data
void Plot::hfill2(int nsets)
{
  int i, ix, iy, h2a_n, idx;
  double xm, ym;
  
#ifdef DEBUG
  cout << "debug: Plot::hfill2 called (ray version)" << endl;
#endif

  h2a_n= h2a_nx * h2a_ny;
  if (h2a) delete h2a; 
  if (h2a_n > 0) h2a= new double[h2a_n]; else h2a= NULL;
  
  for (i= 0; i< h2a_n; i++) h2a[i]= 0.0;    // set array data to 0.0

  if ((zmax- zmin) < ZERO ) zmax = zmin + 1;
  if ((ymax- ymin) < ZERO ) ymax = ymin + 1;  
  h2max= 0.0;

  for (i= 0; i< ndata; i++)
    {
      ix= (int)((c1x[i]- zmin)/(zmax - zmin)* h2a_nx);
      iy= (int)((c1y[i]- ymin)/(ymax - ymin)* h2a_ny);
      
      if ((ix >= 0) && (ix < h2a_nx) && (iy >= 0) && (iy < h2a_ny)) 
	{
	  idx= ix+ iy* h2a_nx;
	  h2a[idx]+= 1.0;          // add one hit
          if (h2a[idx] > h2max) 
	    {
	      xm= c1x[i]; 
	      ym= c1y[i];
	      h2max= h2a[idx];
	    }
	}
    }
  if (nsets == 2)
    {
      for (i= 0; i< ndata; i++)
	{
	  ix= (int)((c2x[i]- zmin)/(zmax - zmin)* h2a_nx);
	  iy= (int)((c2y[i]- ymin)/(ymax - ymin)* h2a_ny);
	  
	  if ((ix >= 0) && (ix < h2a_nx) && (iy >= 0) && (iy < h2a_ny)) 
	    {
	      idx= ix+ iy* h2a_nx;
	      h2a[idx]+= 1.0;          // add one hit
	      if (h2a[idx] > h2max) 
		{
		  xm= c2x[i]; 
		  ym= c2y[i];
		  h2max= h2a[idx];
		}
	    }
	}
    }

  // scale maximum to 10
  if (h2max > 0.0)
    for (ix=0; ix< h2a_nx; ix++)
      for (iy=0; iy< h2a_ny; iy++) h2a[ix+iy*h2a_nx]*= 10.0/ h2max;

 

#ifdef DEBUG
  cout << "debug: " << __FILE__ << " hfill2 end:  h2max= " <<  h2max << ", h2a[last]= " << h2a[h2a_n-1] << endl;
  cout << "debug: " << __FILE__ << " hfill2 end:  max @ x= " << xm << ", y= " << ym << endl;
#endif
} // hfill2 GO

// fills a 2d histogram with ray data PO version
void Plot::hfill2(struct PSDType *rp)
{
  int i, ix, iy, h2a_n;
  double *data;
  
#ifdef DEBUG
  cout << "Plot::hfill2 called (PO version)" << endl;
#endif

  h2a_nx= rp->iz;
  h2a_ny= rp->iy;
  data  = rp->psd;   // in fortran model
  pox   = rp->z;
  poy   = rp->y;

  h2a_n= h2a_nx * h2a_ny;
  if (h2a != NULL) delete h2a;
  if (h2a_n > 0) h2a= new double[h2a_n];
  
  h2max= 0.0;
  for (ix=0; ix< h2a_nx; ix++)
    for (iy=0; iy< h2a_ny; iy++) 
      {
	//h2a[ix + (h2a_ny- iy- 1)* h2a_nx]= data[iy + ix* h2a_ny]; // fortran feld auf c umsortieren und vertikal spiegeln
	// data kommt im fortran modell
	h2a[ix + iy* h2a_nx]= data[iy + ix* h2a_ny]; // fortran feld auf c umsortieren
	// h2max= max(h2max, h2a[ix + (h2a_ny- iy- 1)* h2a_nx]);     // save maximum

	h2max= max(h2max, h2a[ix + iy* h2a_nx]);     // save maximum
      }
  
  // scale maximum to 10
  if (h2max > 0.0)
    for (i=0; i< h2a_n; i++)
       h2a[i]*= 10.0/ h2max;

  //  h2a[0]= 9; // for debugging
  //  h2a[1]= 8;
#ifdef DEBUG
  cout << "debug: " << __FILE__ << " hfill2 end:  hmax=" <<  h2max << endl;
#endif
} // hfill2 PO


// constructor of the plot
//int * Plot::ScatterPlot(QWidget *parent): QwtPlot(parent)
//{
//  int x;
//  return &x;
//
//}

// calculate statistics of an array of rays
void Plot::statistics(struct RayType *rays, int points, double deltalambdafactor, double lambda)
{
  int i;
  struct RayType *rp;
  double fwhmfac;

#ifdef DEBUG  
  cout << "debug: " << __FILE__ << " statistics called, fwhmon=" << fwhmon << ", deltalambdafactor=" << deltalambdafactor << ", lambda=" << lambda << endl;
  // printf("debug: statistics called, fwhmon= %d", fwhmon);
#endif

  //fwhmfac= 2.3548;              // more accurate on request
  fwhmfac= 2.0* sqrt(2.0 * log(2.0));

  cz= cy= wz= wy= cdz= cdy= wdz= wdy= 0.0;

  rp= rays;

  // sum ai and sum ai^2
  for (i=0; i< points; i++, rp++)
    {
      cz += rp->z;
      cy += rp->y;
      cdz+= rp->dz;
      cdy+= rp->dy;
      wz += rp->z * rp->z;
      wy += rp->y * rp->y;
      wdz+= rp->dz* rp->dz;
      wdy+= rp->dy* rp->dy;
    }

  if (points > 0)
    {
      cz /= (double)points;
      wz  = sqrt(wz/points-  cz*cz);
      cy /= (double)points;
      wy  = sqrt(wy/points-  cy*cy);
      cdz/= (double)points;
      wdz = sqrt(wdz/points- cdz*cdz);
      cdy/= (double)points;
      wdy = sqrt(wdy/points- cdy*cdy);
    }

  ry= wy* deltalambdafactor * fwhmfac;   // for resolving power we always take fwhm
  ry= (ry > ZERO) ? lambda/ ry : 0.0;
  rz= wz* deltalambdafactor * fwhmfac;
  rz= (rz > ZERO) ? lambda/ rz : 0.0;

  if (fwhmon)
    {
      wz *= fwhmfac;
      wy *= fwhmfac;
      wdz*= fwhmfac;
      wdy*= fwhmfac;
    }
#ifdef DEBUG  
  cout << "debug " << __FILE__ << " ==> statistics done" << endl;
#endif
} // Plot::statistics

void Plot::appendPoint( const QPointF &point )
{
    CurveData *data = static_cast<CurveData *>( d_curve1->data() );
    data->append( point );
    //   d_directPainter->drawSeries( d_curve1,
    //			       data->size() - 1, data->size() - 1 );
}

void Plot::clearPoints()
{
    CurveData *data = static_cast<CurveData *>( d_curve1->data() );
    data->clear();

    replot();
}

// for test plot
void Plot::getData()
  // produce some dummy data
{
  if (c1x) XFREE(c1x);
  if (c1y) XFREE(c1y);
  if (c2y) XFREE(c2y);
  
  c1x= XMALLOC(double, NPOINTS);
  c1y= XMALLOC(double, NPOINTS);
  c2y= XMALLOC(double, NPOINTS);

  for ( int i= 0; i< NPOINTS; i++ ) 
    {
      c1x[i] = 0.1*i;
      c1y[i] = 1.1*sin(c1x[i]);
      c2y[i] = cos(c1x[i]);
    }
} // end getData()

// the public slot
void Plot::SetLog(bool yes)
{
#ifdef DEBUG
  cout << "debug: slot Plot::SetLog(bool stat) called with yes = " << yes << endl;
#endif

  logscaleon= yes;        // remember status

  if ( !(plotstyle & (PLOT_HPROF | PLOT_VPROF)) )
    {
      cout << "information: This is not a profile plot - Log Scale Button ignored" << endl;
      return;
    }

  int axisId= (plotstyle & PLOT_HPROF) ? QwtPlot::yLeft : QwtPlot::xBottom;
  SetLog(axisId, yes);
} // end SetLog slot

// the private function
void Plot::SetLog(int axisId, bool yes)
{
#ifdef DEBUG
  cout << "debug: slot Plot::SetLog(int axisId, bool yes) called for axisId= " << axisId << endl;
#endif

  //  zoomer->ResetZoomBase();  //needs to be done before setting Engine

  if ( yes )
    {
      if (axisId == QwtPlot::xBottom) x1= h1firstgt0;    
      if (axisId == QwtPlot::yLeft)   y1= h1firstgt0;
    }
  // cout << x1 << " " << x2 << " "<< y1 << " "<< y2 << endl;

  setAxisScale(QwtPlot::xBottom, x1, x2, 0);   // manual scaling, automatic tics
  setAxisScale(QwtPlot::yLeft,   y1, y2, 0);   // manual scaling
  zoomer->setZoomBase(canvas());
    
   //the old ones are deleted by in the setAxisScaleFunction() function see: 128 of file qwt_plot_axis.cpp
  if (yes) 
    {
      setAxisScaleEngine(axisId, new QwtLog10ScaleEngine());
      if (axisId == QwtPlot::xBottom) 
	setAxisScaleEngine(QwtPlot::yLeft, new QwtLinearScaleEngine());
      else 
	setAxisScaleEngine(QwtPlot::xBottom, new QwtLinearScaleEngine());
    }
  else    
    {
      setAxisScaleEngine(QwtPlot::yLeft, new QwtLinearScaleEngine());
      setAxisScaleEngine(QwtPlot::xBottom, new QwtLinearScaleEngine());
    }
  
  //axisScaleEngine(QwtPlot::yLeft)->setAttribute(QwtScaleEngine::Floating);
  //axisScaleEngine(QwtPlot::xBottom)->setAttribute(QwtScaleEngine::Floating);
 
  replot();
} // end SetLog function

void Plot::setPlotStyle(int style)
{
  plotstyle= style;
}

void Plot::setPlotSubject(int style)
{
  plotsubject= style;
}

// end /afs/psi.ch/user/f/flechsig/phase/src/qtgui/plot.cpp
