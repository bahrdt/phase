/*  File      : /afs/psi.ch/user/f/flechsig/phase/src/phaseqt/myzoomer.h */
/*  Date      : <09 Jan 12 10:44:10 flechsig>  */
/*  Time-stamp: <10 Jan 12 16:42:01 flechsig>  */
/*  Author    : Uwe Flechsig, uwe.flechsig&#64;psi.&#99;&#104; */

/*  $Source$  */
/*  $Date$ */
/*  $Revision$  */
/*  $Author$  */

// some code taken from Ian Johnson's  My1DZoomer.h

#ifndef MYZOOMER_H
#define MYZOOMER_H

#include <qwt_plot_zoomer.h>
#include <qwt_plot_panner.h>

class Plot;

class MyZoomer: public QwtPlotZoomer
{
public:
  MyZoomer(QwtPlotCanvas *);

virtual QwtText trackerTextF(const QPointF &pos) const
{
  QColor bg(Qt::white);
  bg.setAlpha(200);
  
  QwtText text = QwtPlotZoomer::trackerTextF(pos);
  text.setBackgroundBrush( QBrush( bg ));
  return text;
} // end trackerTextF
  
private:
  
};
#endif
// end
