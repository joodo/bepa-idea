#ifndef NODESTYLE_H
#define NODESTYLE_H

#include <QObject>
#include <QColor>

#include "jsonableobject.h"

class NodeStyle : public JsonableObject
{
    Q_OBJECT
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(qreal borderWidth READ borderWidth WRITE setBorderWidth NOTIFY borderWidthChanged)
    Q_PROPERTY(QColor borderColor READ borderColor WRITE setBorderColor NOTIFY borderColorChanged)
    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged)
    Q_PROPERTY(int fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(bool underline READ underline WRITE setUnderline NOTIFY underlineChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    QColor m_backgroundColor;

    qreal m_borderWidth;

    QColor m_borderColor;

    qreal m_radius;

    int m_fontSize;

    bool m_underline;

    QString m_name;

public:
    explicit NodeStyle(QObject *parent = 0);

    QColor backgroundColor() const
    {
        return m_backgroundColor;
    }

    qreal borderWidth() const
    {
        return m_borderWidth;
    }

    QColor borderColor() const
    {
        return m_borderColor;
    }

    qreal radius() const
    {
        return m_radius;
    }

    int fontSize() const
    {
        return m_fontSize;
    }

    bool underline() const
    {
        return m_underline;
    }

    QString name() const
    {
        return m_name;
    }

signals:

    void backgroundColorChanged(QColor backgroundColor);

    void borderWidthChanged(qreal borderWidth);

    void borderColorChanged(QColor borderColor);

    void radiusChanged(qreal radius);

    void fontSizeChanged(int fontSize);

    void underlineChanged(bool underline);

    void nameChanged(QString name);

public slots:
    void setBackgroundColor(QColor backgroundColor)
    {
        if (m_backgroundColor == backgroundColor)
            return;

        m_backgroundColor = backgroundColor;
        emit backgroundColorChanged(backgroundColor);
    }
    void setBorderWidth(qreal borderWidth)
    {
        if (m_borderWidth == borderWidth)
            return;

        m_borderWidth = borderWidth;
        emit borderWidthChanged(borderWidth);
    }
    void setBorderColor(QColor borderColor)
    {
        if (m_borderColor == borderColor)
            return;

        m_borderColor = borderColor;
        emit borderColorChanged(borderColor);
    }
    void setRadius(qreal radius)
    {
        if (m_radius == radius)
            return;

        m_radius = radius;
        emit radiusChanged(radius);
    }
    void setFontSize(int fontSize)
    {
        if (m_fontSize == fontSize)
            return;

        m_fontSize = fontSize;
        emit fontSizeChanged(fontSize);
    }
    void setUnderline(bool underline)
    {
        if (m_underline == underline)
            return;

        m_underline = underline;
        emit underlineChanged(underline);
    }
    void setName(QString name)
    {
        if (m_name == name)
            return;

        m_name = name;
        emit nameChanged(name);
    }
};

#endif // NODESTYLE_H
