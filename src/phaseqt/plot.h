/* File      : /afs/psi.ch/user/f/flechsig/phase/src/qtgui/plot.h */
/*  Date      : <08 Jul 11 15:53:58 flechsig>  */
/*  Time-stamp: <13 Mar 15 17:03:28 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

// ******************************************************************************
//
//   Copyright (C) 2014 Helmholtz-Zentrum Berlin, Germany and 
//                      Paul Scherrer Institut Villigen, Switzerland
//   
//   Author Johannes Bahrdt, johannes.bahrdt@helmholtz-berlin.de
//          Uwe Flechsig,    uwe.flechsig@psi.ch
//
// ------------------------------------------------------------------------------
//
//   This file is part of PHASE.
//
//   PHASE is free software: you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation, version 3 of the License, or
//   (at your option) any later version.
//
//   PHASE is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with PHASE (src/LICENSE).  If not, see <http://www.gnu.org/licenses/>. 
//
// ******************************************************************************

#ifndef PLOT_H
#define PLOT_H

//#if (QT_VERSION > 0x050000)
#include <QPrinter>
//#endif

#include <qwt_plot.h>
#include <qwt_plot_spectrogram.h>
#include <qwt_plot_zoomer.h>
#include <qwt_plot_curve.h>
//#include <qwt_plot_directpainter.h>
#include <qwt_scale_engine.h>

#define BINS2   501
#define NPOINTS 501

class MyZoomer;


class Plot: public QwtPlot
{
    Q_OBJECT

public:
  Plot(QWidget * = NULL);
  ~Plot();

    //    int *ScatterPlot(QWidget * = NULL);
    void example3(); // UF
    void setPoData(const char *); // UF
    void setGoData(const char *); // UF
    void setdefaultData();     // UF
    void setdefaultData2();    // UF
    void autoScale(); // GO
    void autoScale(double, double, double, double); // PO
    void fillGoPlotArrays(struct RayType *, int, int, int);
    //void SetData(int n, double* dx, double* dy);
    //int  SetLineColor(int);
    void appendPoint(const QPointF &);
    void clearPoints();
    void getData();       // for test
    void setPlotStyle(int);
    void setPlotSubject(int);
    Plot *plot() { return this; }
    double maxv(double *, int);
    double minv(double *, int);
    
    double ymin;
    double ymax;
    double zmin;
    double zmax;
    double dymin;
    double dymax;
    double dzmin;
    double dzmax;
    double phimin;
    double phimax;
    double *h2a;
    int    h2a_nx, h2a_ny;
    double *pox, *poy ;
    double h2max, h2min;
    double cz, cy, wz, wy, cdz, cdy, wdz, wdy, ry, rz, tt, tt2;  // statistics
    double stmin, stmax, stminy, stmaxy, stminz, stmaxz;         // statistics
    int    fwhmon;
    void   hfill1(double *, double, double, int);
    void   hfill2(int);  // GO
    void   hfill2(struct PSDType *,  int);      // PO result phase
    void   hfill2(struct source4c *, int);      // PO source
    void   hfill2(struct EmfType *, int);       // PO emf
    void   hfill2(struct SurfaceType *);        // PO surface
    void   statistics();                        // PO type
    void   statistics(struct RayType *, int, double, double);  // raytype
    void   contourPlot();
    void   si2by2Plot();
    void   fillData();
    void   scatterPlot(int);
    void   profilePlot(int, int, int);
    QwtPlotSpectrogram *d_spectrogram;
    //  QwtPlotZoomer      *zoomer;
    MyZoomer      *zoomer;
    //QwtPlotDirectPainter *d_directPainter;
    QwtPlotCurve         *d_curve1;
    QwtPlotCurve         *d_curve2;
    
    double *getXdata(int);
    double *getYdata(int);

public Q_SLOTS:
    void showContour(bool on);
    void showSpectrogram(bool on);

public slots:
    void SetLog(bool);

#ifndef QT_NO_PRINTER
    void printPlot(QPrinter & );
#endif

private:
    //QwtPlotSpectrogram *d_spectrogram;
    //double *x, *y;
    double x1, x2, y1, y2;
    double *c1x, *c1y, *c2x, *c2y;
    double h1max, h1firstgt0;
    int    ndata1, ndata2;
    bool   logscaleon;
    int    n_array;
    
    //int    SetUpArrays(int n);
    QPen   *pen_ptr;
    void   Beauty(double *, double *);
    
    struct BeamlineType *bt;
    //QwtPlotZoomer *zoomer;

    void SetLog(int, bool);

    int    plotsubject;  // plot variable
    int    plotstyle;    // plot variable

    
};
#endif
// end
