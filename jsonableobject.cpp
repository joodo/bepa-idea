#include "jsonableobject.h"

JsonableObject::JsonableObject(QObject *parent) : QObject(parent)
{

}

void JsonableObject::load(const QJsonObject &data)
{
    for (auto i = data.begin(); i != data.end(); i++) {
        this->setProperty(i.key().toLatin1().data(), i.value().toVariant());
    }
}
