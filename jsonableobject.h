#ifndef JSONABLEOBJECT_H
#define JSONABLEOBJECT_H

#include <QObject>
#include <QJsonObject>
#include <QVariant>

class JsonableObject : public QObject
{
    Q_OBJECT
public:
    explicit JsonableObject(QObject *parent = 0);
    void load(const QJsonObject& data);

signals:

public slots:
};

#endif // JSONABLEOBJECT_H
